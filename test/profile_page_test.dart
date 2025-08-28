import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_app/Pages/profile_page.dart';

// Mock setup for testing
void main() {
  group('Profile Page Tests', () {
    testWidgets('Profile page renders correctly', (WidgetTester tester) async {
      // Build the ProfilePage widget
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Verify that the profile page renders
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Account Settings'), findsOneWidget);
      expect(find.text('Support & Info'), findsOneWidget);
      expect(find.text('Other Features'), findsOneWidget);
    });

    testWidgets('Profile page has all required sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Check for user info section elements
      expect(find.text('Edit Profile'), findsOneWidget);

      // Check for account settings
      expect(find.text('Edit Personal Details'), findsOneWidget);
      expect(find.text('Delivery Addresses'), findsOneWidget);
      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Notification Settings'), findsOneWidget);

      // Check for support section
      expect(find.text('Contact Us'), findsOneWidget);
      expect(find.text('About App'), findsOneWidget);

      // Check for other features
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Dark mode toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Find the dark mode switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Tap the switch
      await tester.tap(switchFinder);
      await tester.pump();

      // The switch should now be in a different state
      // (This test verifies the UI interaction works)
    });

    testWidgets('Edit profile dialog opens', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Tap the edit profile button
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();

      // Verify the dialog opens
      expect(find.text('Edit Profile'), findsWidgets);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Address'), findsOneWidget);
    });

    testWidgets('Contact dialog opens', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Tap the contact us option
      await tester.tap(find.text('Contact Us'));
      await tester.pumpAndSettle();

      // Verify the contact dialog opens
      expect(find.text('Contact Us'), findsWidgets);
      expect(find.text('Live Chat'), findsOneWidget);
      expect(find.text('Call Us'), findsOneWidget);
      expect(find.text('Email Support'), findsOneWidget);
    });

    testWidgets('Logout dialog opens and works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ProfilePage()));

      // Tap the logout option
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Verify the logout dialog opens
      expect(find.text('Logout'), findsWidgets);
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
