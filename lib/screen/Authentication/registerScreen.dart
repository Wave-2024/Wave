import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/providers/usernameProvider.dart';
import 'package:nexus/screen/Authentication/authscreen.dart';
import 'package:nexus/screen/General/WelcomeScreen.dart';
import 'package:nexus/screen/General/decideScreen.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

import '../General/homescreen.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  bool? isLoading;
  bool? isScreenLoading;
  bool init =
      true; // did change dependency will run only once while starting the page
  TextEditingController? email;
  TextEditingController? password;
  TextEditingController? fullName;
  TextEditingController? username;
  final _formKey = GlobalKey<FormState>();
  final authservice _auth = authservice(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();
    isScreenLoading = true;
    isLoading = false;
    email = TextEditingController();
    password = TextEditingController();
    fullName = TextEditingController();
    username = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (init) {
      Provider.of<usernameProvider>(context).setUserNames().then((value) {
        isScreenLoading = false;
        init = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool>? listOfUserNames =
        Provider.of<usernameProvider>(context).fetchUserNames;

    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: (isScreenLoading!)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/register.jpg',
                        height: displayHeight(context) * 0.3,
                        width: displayWidth(context),
                        fit: BoxFit.cover,
                      ),
                      Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: displayHeight(context) * 0.002,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Text(
                          'Register to Wave !!',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.063),
                        ),
                      ),
                      Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: displayHeight(context) * 0.022,
                          )),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 18.0, right: 18),
                        child:  TextFormField(
                                controller: fullName,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: displayWidth(context) * 0.04),
                                  hintText: 'Alpha',
                                  labelText: "Full Name",
                                ),
                              ),
                            ),

                       Padding(
                         padding: const EdgeInsets.only(
                             top: 10, left: 18.0, right: 18),
                         child: TextFormField(
                                  controller: username,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cannot be empty';
                                    }
                                    if (listOfUserNames!.containsKey(value)) {
                                      return 'username already taken';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: displayWidth(context) * 0.04),
                                    hintText: 'alpha17-2',
                                    labelText: "Username",
                                  ),
                                ),
                       ),

                       Padding(
                         padding: const EdgeInsets.only(
                             top: 10, left: 18.0, right: 18),
                         child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Cannot be empty';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: displayWidth(context) * 0.04),
                                    hintText: 'alpha77@yahoo.com',
                                    labelText: "Email"
                                  ),
                                ),
                       ),


                       Padding(
                         padding: const EdgeInsets.only(
                             top: 10, left: 18.0, right: 18),
                         child: TextFormField(
                                  obscureText: true,
                                  controller: password,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Cannot be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: displayWidth(context) * 0.04),
                                    hintText: '*******',
                                    labelText: "Password"
                                  ),
                                ),
                       ),
                      Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: displayHeight(context) * 0.028,
                          )),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _auth
                                  .signUp(
                                email: email!.text.toString(),
                                password: password!.text.toString(),
                                title: fullName!.text.toString(),
                                username: username!.text.toString(),
                              )
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (value != 'valid') {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text(value!),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Try again"))
                                            ],
                                          ));
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => decideScreen(),
                                      ));
                                }
                              });
                            }
                          },
                          child: Container(
                            height: displayHeight(context) * 0.06,
                            width: displayWidth(context) * 0.8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.deepOrange,
                                    Colors.deepOrangeAccent,
                                    Colors.orange[600]!,
                                  ]),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.04),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: displayHeight(context) * 0.005,
                          )),
                      Center(
                        child: TextButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => authScreen(),
                                )),
                            child: (isLoading!)
                                ? CircularProgressIndicator()
                                : Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.045,
                                      color: Colors.black54,
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
