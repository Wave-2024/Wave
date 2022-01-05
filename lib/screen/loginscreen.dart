import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screen/homescreen.dart';
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
                                  builder: (context) => homescreen(),
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
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.045,
                              color: Colors.black54,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            // todo -> Forgot password algorithm
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
