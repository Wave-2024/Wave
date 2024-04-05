import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/utils/constants.dart';
import 'package:wave/view/screens/Authentication/login_screen.dart';

void main() {


  testWidgets('Login screen should render widgets', (WidgetTester tester) async {
    // Wrap the LoginScreen widget with MultiProvider containing the required providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
          create: (context) => AuthScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ],
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Test widget rendering
    expect(find.text('Login'), findsAtLeast(1));
    expect(find.text('Email'), findsAtLeast(1));
    expect(find.text('Password'), findsAtLeast(1));
    expect(find.text('Forgot Password?'), findsAtLeast(1));
    expect(find.text('Login with Google'), findsAtLeast(1));
    expect(find.text('Don\'t have an account?'), findsAtLeast(1));
    expect(find.text('Register Now'), findsAtLeast(1));
  });

  testWidgets('Login screen form validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
          create: (context) => AuthScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ],
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Find text fields and submit button
    final loginEmailTextField = find.byKey( Key(keyForEmailTextFieldLogin));
    final loginPasswordTextField = find.byKey(Key(keyForPasswordTextFieldLogin));
    final loginButton = find.byKey(Key(keyForLoginButton));

    // Invalid email and password
    await tester.enterText(loginEmailTextField, 'invalidgmail');
    await tester.enterText(loginPasswordTextField, '');
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

  });
}
