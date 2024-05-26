//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/models/response_model.dart' as res;
import 'package:wave/models/user_model.dart';
import 'package:wave/services/auth_services.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/constants/keys.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/utils/util_functions.dart';
import 'package:wave/view/reusable_components/auth_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscuredText = false;

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
              CustomColor.primaryGradient2,
              CustomColor.primaryGradient1,
              CustomColor.primaryGradient1,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
                top: displayHeight(context) * 0.08,
                child: Image.asset(
                  CustomLogo.primaryLogo,
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
                            fontFamily: CustomFont.poppins,
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
                            uniqueKey: Keys.keyForEmailTextFieldLogin,
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
                      Consumer<AuthScreenController>(
                        builder: (context, authController, child) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                            child: AuthTextField(
                                uniqueKey: Keys.keyForPasswordTextFieldLogin,
                                controller: passwordController,
                                label: "Password",
                                visible: authController.obscuredTextLogin,
                                prefixIcon: const Icon(Icons.password),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    authController
                                        .togglePasswordVisibilityLogin();
                                  },
                                  child: Icon(authController.obscuredTextLogin
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                validator: (password) {
                                  if (password == null || password.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                }),
                          );
                        },
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
                              fontFamily: CustomFont.poppins,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Consumer2<AuthScreenController, UserDataController>(
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
                                  res.CustomResponse loginResponse =
                                      await authController.startLoginProcess(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          firebaseAuth:
                                              fb.FirebaseAuth.instance);

                                  // Successful login
                                  if (loginResponse.responseStatus) {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    fb.UserCredential userCredential =
                                        loginResponse.response
                                            as fb.UserCredential;
                                    await prefs.setBool(Pref.login_pref, true);
                                    await prefs.setString(
                                        Pref.user_id, userCredential.user!.uid);
                                    await userController.setUser(
                                        userID: userCredential.user!.uid);
                                    Get.showSnackbar(GetSnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                      borderRadius: 5,
                                      title: "Login Success",
                                      message: userController.user!.name,
                                    ));
                                    Get.offAllNamed(
                                        AppRoutes.homeNavigationScreen,
                                        parameters: {'screenIndex': '0'});
                                  }
                                  // Login failed
                                  else {
                                    Get.showSnackbar(GetSnackBar(
                                      backgroundColor: CustomColor.errorColor,
                                      borderRadius: 5,
                                      title: "Login Failed",
                                      duration: const Duration(seconds: 2),
                                      message: loginResponse.response.message
                                          .toString(),
                                    ));
                                  }
                                }
                              },
                              color: CustomColor.primaryButtonColor,
                              child: authController.loginState == LOGIN.IDLE
                                  ? Text(
                                      key: const Key(Keys.keyForLoginButton),
                                      "Login",
                                      style: TextStyle(
                                          fontFamily: CustomFont.poppins,
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
                      Consumer2<AuthScreenController, UserDataController>(
                        builder: (context, authController, userDataController,
                            child) {
                          return SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              onPressed: () async {
                                res.CustomResponse loginWithResponse =
                                    await authController.loginWithGoogle(
                                        firebaseAuth: fb.FirebaseAuth.instance);
                                if (loginWithResponse.responseStatus) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  fb.UserCredential googleUserCredential =
                                      loginWithResponse.response
                                          as fb.UserCredential;

                                  if (googleUserCredential
                                      .additionalUserInfo!.isNewUser) {
                                    String username = await getUniqueUsername(
                                        capitalizeWords(googleUserCredential
                                            .user!.displayName!));
                                    String? fcmToken = await FirebaseMessaging
                                        .instance
                                        .getToken();
                                    await userDataController.createUser(
                                        user: User(
                                            fcmToken: fcmToken!,
                                            verified: false,
                                            name: capitalizeWords(
                                                googleUserCredential
                                                    .user!.displayName!),
                                            email: googleUserCredential
                                                .user!.email!,
                                            following: [],
                                            followers: [],
                                            posts: [],
                                            id: googleUserCredential.user!.uid,
                                            username: username,
                                            stories: [],
                                            blocked: [],
                                            coverPicture: "",
                                            account_type: ACCOUNT_TYPE.PUBLIC));
                                  } else {
                                    await userDataController.setUser(
                                        userID: googleUserCredential.user!.uid);
                                  }

                                  await prefs.setBool(Pref.login_pref, true);
                                  await prefs.setString(Pref.user_id,
                                      googleUserCredential.user!.uid);

                                  Get.showSnackbar(GetSnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                    borderRadius: 5,
                                    title: "Login Success",
                                    message: userDataController.user!.name,
                                  ));
                                  Get.offAllNamed(
                                      AppRoutes.homeNavigationScreen,
                                      parameters: {'screenIndex': '0'});
                                } else {
                                  Get.showSnackbar(GetSnackBar(
                                    backgroundColor: CustomColor.errorColor,
                                    borderRadius: 5,
                                    title: "Login Failed",
                                    duration: const Duration(seconds: 2),
                                    message: loginWithResponse.response.message
                                        .toString(),
                                  ));
                                }
                              },
                              color: CustomColor.authTextBoxColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Brand(Brands.google),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Login with Google",
                                    style: TextStyle(
                                        fontFamily: CustomFont.poppins,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                                  fontFamily: CustomFont.poppins,
                                  color: Colors.black),
                            ),
                            TextButton(
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                    fontFamily: CustomFont.poppins,
                                    color: CustomColor.primaryColor,
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
