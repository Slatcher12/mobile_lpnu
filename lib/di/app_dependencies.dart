import 'package:flutter/material.dart';

class AppDependencies extends InheritedWidget {
  final ValueNotifier<bool> isOnline;

  const AppDependencies({
    super.key,
    required this.isOnline,
    required super.child,
  });

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>()!;

  @override
  bool updateShouldNotify(AppDependencies old) => false;
}
