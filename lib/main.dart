import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'view/screens/Authentication/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Wave());
}

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(home: LoginScreen());
  }
}
