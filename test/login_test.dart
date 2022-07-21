import 'package:flutter_test/flutter_test.dart';
import 'package:back2campus/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  group("Splash page", () {
    testWidgets('Redirection testing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MyApp());

      // Verify that first page is splash page
      expect(find.text('An easier navigation around NUS'),
          findsOneWidget); // splash page
      //expect(find.text('Sign Up'), findsNothing);

      // Tap the 'CREATE ACCOUNT' icon.
      await tester.tap(find.widgetWithText(ElevatedButton, 'CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Verify that we are redirected to sign up page.
      expect(find.text('Sign Up'), findsOneWidget);

      // Tap the 'BACK TO HOME' button.
      await tester.tap(find.widgetWithText(ElevatedButton, 'BACK TO HOME'));
      await tester.pumpAndSettle();

      // Verify that we are redirected back to splash page.
      expect(find.text('An easier navigation around NUS'),
          findsOneWidget);

      // Tap the 'SIGN IN' button.
      await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pumpAndSettle();

      // Verify that we are redirected to sign in page.
      expect(find.text('Welcome back'), findsOneWidget);



      // Tap the 'BACK TO HOME' button.
      await tester.tap(find.widgetWithText(ElevatedButton, 'BACK TO HOME'));
      await tester.pumpAndSettle();

      // Verify that we are redirected back to splash page.
      expect(find.text('An easier navigation around NUS'),
          findsOneWidget);
    });
  });

  /*
  group("Sign In Page", () {
    testWidgets('Authentication testing', (WidgetTester tester) async {
      // Supabase Initialization
      WidgetsFlutterBinding.ensureInitialized();

      await Supabase.initialize(
        url: 'https://rlemxzljabcaylnhetcv.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsZW14emxqYWJjYXlsbmhldGN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTM4ODQ5NjIsImV4cCI6MTk2OTQ2MDk2Mn0.ENIdAS3--1XgqT3Ufizp8bwpQSml0xSdUr8M8IR6nVo',
      );
      // End of Supabase Initialization

      // Build our app and trigger a frame.
      await tester.pumpWidget(new MyApp());
      // Verify that first page is splash page
      expect(find.text('An easier navigation around NUS'),
          findsOneWidget); // splash page

      // Tap the 'SIGN IN' button.
      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pumpAndSettle();

      // Verify that we are redirected to sign in page.
      expect(find.text('Welcome back'), findsOneWidget);
      // Enter incorrect details to textfields and submit
      await tester.ensureVisible(find.text("Email"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('emailTextFieldKey')), 'thinhong99@gmail.com');
      await tester.enterText(find.byKey(const Key('passwordTextFieldKey')), 'aaa');
      await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pumpAndSettle();

      // Verify that we are not redirected to other page (Login fail).
      expect(find.text('Welcome back'), findsOneWidget);


      // Enter correct details to textfields and submit
      await tester.enterText(find.byKey(const Key('emailTextFieldKey')), 'thinhong99@gmail.com');
      await tester.enterText(find.byKey(const Key('passwordTextFieldKey')), '1234567890');
      await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pumpAndSettle();

      // Verify that we are redirected to static map page (Login successful).
      expect(find.text('Locate NUS buildings'), findsOneWidget);
    });
  });

   */
}


