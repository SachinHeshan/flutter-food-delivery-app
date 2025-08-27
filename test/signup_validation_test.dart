import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_app/Pages/signup.dart';

void main() {
  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Shows errors when submitting empty form', (tester) async {
    await tester.pumpWidget(buildTestable(const SignUp()));

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('Invalid email shows validation error', (tester) async {
    await tester.pumpWidget(buildTestable(const SignUp()));

    await tester.enterText(find.bySemanticsLabel('Full Name'), 'John Doe');
    await tester.enterText(find.bySemanticsLabel('Email'), 'invalid-email');
    await tester.enterText(find.bySemanticsLabel('Password'), '123456');
    await tester.enterText(find.bySemanticsLabel('Confirm Password'), '123456');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Weak password shows validation error', (tester) async {
    await tester.pumpWidget(buildTestable(const SignUp()));

    await tester.enterText(find.bySemanticsLabel('Full Name'), 'John Doe');
    await tester.enterText(find.bySemanticsLabel('Email'), 'john@example.com');
    await tester.enterText(find.bySemanticsLabel('Password'), '123');
    await tester.enterText(find.bySemanticsLabel('Confirm Password'), '123');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Mismatched passwords shows validation error', (tester) async {
    await tester.pumpWidget(buildTestable(const SignUp()));

    await tester.enterText(find.bySemanticsLabel('Full Name'), 'John Doe');
    await tester.enterText(find.bySemanticsLabel('Email'), 'john@example.com');
    await tester.enterText(find.bySemanticsLabel('Password'), '123456');
    await tester.enterText(find.bySemanticsLabel('Confirm Password'), '1234567');

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}


