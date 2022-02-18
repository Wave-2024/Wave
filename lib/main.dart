import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/screenIndexProvider.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/providers/usernameProvider.dart';
import 'package:nexus/screen/Authentication/authscreen.dart';
import 'package:nexus/screen/General/decideScreen.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/services/auth_notifier.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthNotifier(),
          ),
          Provider<authservice>(
              create: (_) => authservice(FirebaseAuth.instance)),
          StreamProvider(
            create: (context) => context.read<authservice>().austhStateChanges,
            initialData: null,
          ),
          ChangeNotifierProvider(create: (context) => usernameProvider()),
          ChangeNotifierProvider(
            create: (context) => screenIndexProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => manager(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthNotifier>(
              builder: (context, notifier, child) {
                return notifier.user != null ? decideScreen() : wrapper();
              },
            )));
  }
}

class wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return decideScreen();
    } else {
      return const authScreen();
    }
  }
}
