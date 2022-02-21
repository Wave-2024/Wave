
/*
Copyright © 2022 Subhojeet Sahoo

Being Open Source doesn't mean you can just make a copy of the app and upload it on playstore or sell
a closed source copy of the same.
Read the following carefully:

1. Any copy of a software under GPL must be under same license. So you can't upload the app on a closed source
  app repository like PlayStore/AppStore without distributing the source code.
2. You can't sell any copied/modified version of the app under any "non-free" license.
   You must provide the copy with the original software or with instructions on how to obtain original software,
   should clearly state all changes, should clearly disclose full source code, should include same license
   and all copyrights should be retained.

In simple words, You can ONLY use the source code of this app for `Open Source` Project under `GPL v3.0` or later
with all your source code CLEARLY DISCLOSED on any code hosting platform like GitHub, with clear INSTRUCTIONS on
how to obtain the original software, should clearly STATE ALL CHANGES made and should RETAIN all copyrights.
Use of this software under any "non-free" license is NOT permitted.

 */


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
