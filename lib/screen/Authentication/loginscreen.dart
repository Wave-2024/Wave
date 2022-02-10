import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screen/Authentication/authscreen.dart';
import 'package:nexus/screen/General/WelcomeScreen.dart';
import 'package:nexus/screen/General/decideScreen.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/loginClipper.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController? email;
  TextEditingController? password;
  bool? isLoading;
  final _formKey = GlobalKey<FormState>();
  final _formKeyForForgetPass = GlobalKey<FormState>();
  final authservice _auth = authservice(FirebaseAuth.instance);
  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    email!.dispose();
    password!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: LoginClipper(),
                  child: Container(
                    height: displayHeight(context) * 0.45,
                    width: displayWidth(context),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/login.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 18),
                  child: Text(
                    'Welcome Back !',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.065),
                  ),
                ),
                const Opacity(
                  opacity: 0.0,
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Email",
                      hintText: "alpha77@yahoo.com",
                    ),
                  ),
                ),
                const Opacity(
                  opacity: 0.0,
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Password",
                      hintText: "********",
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Divider(
                    height: displayHeight(context) * 0.04,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        _auth
                            .signIn(
                                email: email!.text.toString(),
                                password: password!.text.toString())
                            .then((value) {
                          print(value);
                          if (value != 'valid') {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text(value!),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Try again"))
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
                      height: displayHeight(context) * 0.07,
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
                        child: (isLoading!)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Log In',
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
                    height: displayHeight(context) * 0.08,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => authScreen(),
                              )),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.045,
                              color: Colors.black54,
                            ),
                          )),
                      TextButton(
                          onPressed: () async {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Form(
                                            key: _formKeyForForgetPass,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: "Email",
                                                hintText:
                                                    "officialwave@gmail.com",
                                              ),
                                              controller: email,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Cannot be empty";
                                                } else {
                                                  bool emailValid = RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value);
                                                  if (!emailValid) {
                                                    return "Please provide a valid email address";
                                                  } else {
                                                    return null;
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          const Opacity(
                                              opacity: 0.0, child: Divider()),
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKeyForForgetPass
                                                  .currentState!
                                                  .validate()) {
                                                final response =
                                                    await _auth.resetPassword(
                                                        email!.text.toString());
                                                if (response == 'ok') {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Password reset link has been sent to your email.")));
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content:
                                                              Text(response!)));
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Reset',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.orangeAccent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.045,
                              color: Colors.indigo,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
