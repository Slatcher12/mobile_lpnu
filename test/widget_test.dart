import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_lpnu/main.dart';

void main() {
  testWidgets('login screen renders correctly', (tester) async {
    await tester.pumpWidget(const CoffeeApp());
    expect(find.text('Smart Coffee'), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('login screen has email and password fields', (tester) async {
    await tester.pumpWidget(const CoffeeApp());
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('login screen has register link', (tester) async {
    await tester.pumpWidget(const CoffeeApp());
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
