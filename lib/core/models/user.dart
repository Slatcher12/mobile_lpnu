import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  User copyWith({String? name, String? email, String? password}) => User(
    id: id,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
  );

  static List<User> listFromJson(String raw) => (jsonDecode(raw) as List)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList();
}
