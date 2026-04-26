import 'dart:convert';

class CoffeeMachine {
  final String id;
  final String userId;
  final String name;
  final String model;
  final bool isOnline;

  const CoffeeMachine({
    required this.id,
    required this.userId,
    required this.name,
    required this.model,
    required this.isOnline,
  });

  CoffeeMachine copyWith({String? name, String? model, bool? isOnline}) =>
      CoffeeMachine(
        id: id,
        userId: userId,
        name: name ?? this.name,
        model: model ?? this.model,
        isOnline: isOnline ?? this.isOnline,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'model': model,
    'isOnline': isOnline,
  };

  factory CoffeeMachine.fromJson(Map<String, dynamic> json) => CoffeeMachine(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    model: json['model'] as String,
    isOnline: json['isOnline'] as bool,
  );

  static List<CoffeeMachine> listFromJson(String raw) =>
      (jsonDecode(raw) as List)
          .map((e) => CoffeeMachine.fromJson(e as Map<String, dynamic>))
          .toList();
}
