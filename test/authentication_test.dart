import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';
import 'package:wave/view/screens/Authentication/register_screen.dart';

void main() {
  testWidgets('Login screen form validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthScreenController(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserDataController(),
          ),
        ],
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Find text fields and submit button
    final loginEmailTextField = find.byKey(Key(keyForEmailTextFieldLogin));
    final loginPasswordTextField =
        find.byKey(Key(keyForPasswordTextFieldLogin));
    final loginButton = find.byKey(Key(keyForLoginButton));

    // Invalid email and password
    await tester.enterText(loginEmailTextField, 'invalidgmail');
    await tester.enterText(loginPasswordTextField, '');
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Register screen form validation test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthScreenController(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserDataController(),
          ),
        ],
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Find text fields and submit button
    final nameTextField = find.byKey(Key(keyForNameBoxRegister));
    final emailTextField = find.byKey(Key(keyForEmailTextFieldRegister));
    final passwordTextField = find.byKey(Key(keyForPasswordTextFieldRegister));
    final registerButton = find.byKey(Key(keyForRegisterButton));

    // Empty name, email, and password
    await tester.enterText(nameTextField, '');
    await tester.enterText(emailTextField, '');
    await tester.enterText(passwordTextField, '');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Name cannot be empty'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // Only email is empty
    await tester.enterText(nameTextField, 'John Doe');
    await tester.enterText(emailTextField, '');
    await tester.enterText(passwordTextField, 'password123');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsNothing);

    // Only password is empty
    await tester.enterText(nameTextField, 'John Doe');
    await tester.enterText(emailTextField, 'john@example.com');
    await tester.enterText(passwordTextField, '');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Email is required'), findsNothing);

    // Email and password are empty
    await tester.enterText(nameTextField, 'John Doe');
    await tester.enterText(emailTextField, '');
    await tester.enterText(passwordTextField, '');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    // Name is only empty
    await tester.enterText(nameTextField, '');
    await tester.enterText(emailTextField, 'john@example.com');
    await tester.enterText(passwordTextField, 'password123');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Name cannot be empty'), findsOneWidget);
    expect(find.text('Email is required'), findsNothing);
    expect(find.text('Password is required'), findsNothing);

    // Email is not valid
    await tester.enterText(nameTextField, 'John Doe');
    await tester.enterText(emailTextField, 'invalid_email');
    await tester.enterText(passwordTextField, 'password123');
    await tester.tap(registerButton);
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
  });
}
