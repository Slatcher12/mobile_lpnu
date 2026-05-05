import asyncio
import logging
from amqtt.broker import Broker

logging.basicConfig(level=logging.WARNING)
logging.getLogger('amqtt.broker').setLevel(logging.DEBUG)
logging.getLogger('amqtt.mqtt').setLevel(logging.DEBUG)

CONFIG = {
    'listeners': {
        'default': {
            'type': 'tcp',
            'bind': '127.0.0.1:1883',
        },
        'ws': {
            'type': 'ws',
            'bind': '127.0.0.1:9001',
        },
    },
    'auth': {
        'allow-anonymous': True,
    },
    'topic-check': {
        'enabled': False,
    },
    'sys_interval': 20,
}


async def main():
    broker = Broker(CONFIG)
    await broker.start()
    print("Broker running: TCP :1883  |  WebSocket :9001")
    print("Press Ctrl+C to stop.\n")
    try:
        await asyncio.Future()
    except (KeyboardInterrupt, asyncio.CancelledError):
        pass
    finally:
        await broker.shutdown()


if __name__ == '__main__':
    asyncio.run(main())
