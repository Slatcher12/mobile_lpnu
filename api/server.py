from fastapi import FastAPI, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import uvicorn
import uuid

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_methods=['*'],
    allow_headers=['*'],
)

_users: dict = {}
_machines: dict = {}
_tokens: dict = {}


class RegisterBody(BaseModel):
    name: str
    email: str
    password: str


class LoginBody(BaseModel):
    email: str
    password: str


class UserBody(BaseModel):
    name: str
    email: str


class MachineBody(BaseModel):
    userId: str
    name: str
    model: str
    isOnline: bool = True


def _require_auth(authorization: Optional[str]) -> str:
    if not authorization or not authorization.startswith('Bearer '):
        raise HTTPException(401, 'Unauthorized')
    uid = _tokens.get(authorization[7:])
    if not uid:
        raise HTTPException(401, 'Invalid token')
    return uid


def _public_user(u: dict) -> dict:
    return {k: v for k, v in u.items() if k != 'password'}


@app.post('/auth/register')
def register(body: RegisterBody):
    if any(u['email'] == body.email for u in _users.values()):
        raise HTTPException(400, 'Email already exists')
    uid = str(uuid.uuid4())
    _users[uid] = {'id': uid, 'name': body.name, 'email': body.email, 'password': body.password}
    token = str(uuid.uuid4())
    _tokens[token] = uid
    return {'token': token, 'user': _public_user(_users[uid])}


@app.post('/auth/login')
def login(body: LoginBody):
    user = next((u for u in _users.values()
                 if u['email'] == body.email and u['password'] == body.password), None)
    if not user:
        raise HTTPException(401, 'Invalid credentials')
    token = str(uuid.uuid4())
    _tokens[token] = user['id']
    return {'token': token, 'user': _public_user(user)}


@app.get('/users/{uid}')
def get_user(uid: str, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    user = _users.get(uid)
    if not user:
        raise HTTPException(404, 'Not found')
    return _public_user(user)


@app.put('/users/{uid}')
def update_user(uid: str, body: UserBody, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    user = _users.get(uid)
    if not user:
        raise HTTPException(404, 'Not found')
    user.update({'name': body.name, 'email': body.email})
    return _public_user(user)


@app.delete('/users/{uid}')
def delete_user(uid: str, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    _users.pop(uid, None)
    for mid in [k for k, m in _machines.items() if m['userId'] == uid]:
        _machines.pop(mid)
    return {'ok': True}


@app.get('/machines')
def get_machines(userId: str, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    return [m for m in _machines.values() if m['userId'] == userId]


@app.post('/machines')
def create_machine(body: MachineBody, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    mid = str(uuid.uuid4())
    machine = {'id': mid, **body.model_dump()}
    _machines[mid] = machine
    return machine


@app.put('/machines/{mid}')
def update_machine(mid: str, body: MachineBody, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    if mid not in _machines:
        raise HTTPException(404, 'Not found')
    _machines[mid] = {'id': mid, **body.model_dump()}
    return _machines[mid]


@app.delete('/machines/{mid}')
def delete_machine(mid: str, authorization: Optional[str] = Header(None)):
    _require_auth(authorization)
    _machines.pop(mid, None)
    return {'ok': True}


if __name__ == '__main__':
    uvicorn.run(app, host='localhost', port=8080)
