import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/models/response_model.dart' as res;
import 'package:wave/utils/constants.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/auth_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryGradient2,
              primaryGradient1,
              primaryGradient1,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
                top: displayHeight(context) * 0.08,
                child: Image.asset(
                  primaryLogo,
                  height: 80,
                  width: 100,
                  fit: BoxFit.contain,
                )),
            Container(
              height: displayHeight(context) * 0.78,
              width: displayWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            fontFamily: poppins,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 40),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                        child: AuthTextField(
                            controller: emailController,
                            label: "Email",
                            visible: true,
                            prefixIcon: const Icon(Icons.mail),
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Email is required';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(email)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                        child: AuthTextField(
                            controller: passwordController,
                            label: "Password",
                            visible: false,
                            prefixIcon: const Icon(Icons.password),
                            validator: (password) {
                              if (password == null || password.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontFamily: poppins,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Consumer2<AuthScreenController, UserController>(
                        builder:
                            (context, authController, userController, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Try to Login
                                  res.Response loginResponse =
                                      await authController.startLoginProcess(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          firebaseAuth:
                                              fb.FirebaseAuth.instance);
                                  // Successful login
                                  if (loginResponse.responseStatus) {
                                    fb.UserCredential userCredential =
                                        loginResponse.response
                                            as fb.UserCredential;
                                    await userController.setUser(
                                        userID: userCredential.user!.uid);
                                    Get.showSnackbar(GetSnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                      borderRadius: 5,
                                      title: "Login Success",
                                      message: userController.user!.name,
                                    ));
                                  }
                                  // Login failed
                                  else {
                                    Get.showSnackbar(GetSnackBar(
                                      backgroundColor: errorColor,
                                      borderRadius: 5,
                                      duration: const Duration(seconds: 2),
                                      message: loginResponse.response.message
                                          .toString(),
                                    ));
                                  }
                                }
                              },
                              color: primaryButtonColor,
                              child: authController.loginState == LOGIN.IDLE
                                  ? Text(
                                      "Login",
                                      style: TextStyle(
                                          fontFamily: poppins,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.08,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                indent: 15,
                                endIndent: 15,
                              ),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                indent: 15,
                                endIndent: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          height: 50,
                          onPressed: () {},
                          color: authTextBoxColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Brand(Brands.google),
                              const SizedBox(width: 10),
                              Text(
                                "Login with Google",
                                style: TextStyle(
                                    fontFamily: poppins,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontFamily: poppins, color: Colors.black),
                            ),
                            TextButton(
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                    fontFamily: poppins,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Get.toNamed(AppRoutes.registerScreen);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
