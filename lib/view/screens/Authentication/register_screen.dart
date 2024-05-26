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
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/constants/keys.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/utils/util_functions.dart';
import 'package:wave/view/reusable_components/auth_textfield.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obsureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(size: 35),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Create New Account",
                  style: TextStyle(
                      fontFamily: CustomFont.poppins,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 35),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: AuthTextField(
                      uniqueKey: Keys.keyForNameBoxRegister,
                      controller: nameController,
                      label: "Name",
                      visible: true,
                      prefixIcon: const Icon(Icons.mail),
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return "Name cannot be empty";
                        }
                        if (name.length > 25) {
                          return "Name cannot be longer than 25 characters";
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
                  elevation: 1,
                  child: AuthTextField(
                      uniqueKey: Keys.keyForEmailTextFieldRegister,
                      controller: emailController,
                      label: "Email",
                      visible: true,
                      prefixIcon: const Icon(Icons.mail),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                          visible: authController.obscuredTextReg,
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              authController.togglePasswordVisibilityReg();
                            },
                            child: Icon(authController.obscuredTextReg
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
                ), // The below code is commented only for smooth and faster dev process . Add it before production

                // else if (!RegExp(
                //         r'^(?=.*[a-zA-Z].*[a-zA-Z])(?=.*\d.*\d)(?=.*[^a-zA-Z0-9].*[^a-zA-Z0-9]).{6,}$')
                //     .hasMatch(password)) {
                //   return 'Password must contain at least 2 alphabets, 2 digits, and 2 special characters';
                // }
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Consumer2<AuthScreenController, UserDataController>(
                    builder: (context, authController, userController, child) {
                      return MaterialButton(
                        key: Key(Keys.keyForRegisterButton),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Try to register
                            res.CustomResponse registrationResponse =
                                await authController.startRegistrationProcess(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    firebaseAuth: fb.FirebaseAuth.instance);

                            // If registration is successful
                            if (registrationResponse.responseStatus) {
                              fb.UserCredential userCredential =
                                  registrationResponse.response
                                      as fb.UserCredential;
                              String name = nameController.text.trim();
                              String? fcmToken =
                                  await FirebaseMessaging.instance.getToken();
                              name = capitalizeWords(name);
                              String userName = await getUniqueUsername(name);
                              User currentUser = User(
                                  fcmToken: fcmToken!,
                                  verified: false,
                                  account_type: ACCOUNT_TYPE.PUBLIC,
                                  name: name,
                                  email: emailController.text,
                                  displayPicture: "",
                                  bio: "I am new to Wave",
                                  messages: [],
                                  savedPosts: [],
                                  url: "",
                                  following: [],
                                  followers: [],
                                  posts: [],
                                  id: userCredential.user!.uid,
                                  username: userName,
                                  stories: [],
                                  blocked: [],
                                  coverPicture: "");
                              await userController.createUser(
                                  user: currentUser);

                              Get.showSnackbar(GetSnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green,
                                borderRadius: 5,
                                message: userController.user!.name,
                              ));
                              Get.offNamed(AppRoutes.homeNavigationScreen);
                            }
                            // If registration failed
                            else {
                              Get.showSnackbar(GetSnackBar(
                                backgroundColor: CustomColor.errorColor,
                                borderRadius: 5,
                                duration: const Duration(seconds: 2),
                                message: registrationResponse.response.message
                                    .toString(),
                              ));
                            }
                          }
                        },
                        color: CustomColor.primaryButtonColor,
                        child: (authController.registerState == REGISTER.IDLE)
                            ? Text(
                                "Register",
                                style: TextStyle(
                                    fontFamily: CustomFont.poppins,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.1,
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
                  builder:
                      (context, authController, userDataController, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        onPressed: () async {
                          res.CustomResponse loginWithGoogleResponse =
                              await authController.loginWithGoogle(
                                  firebaseAuth: fb.FirebaseAuth.instance);
                          if (loginWithGoogleResponse.responseStatus) {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            fb.UserCredential googleUserCredential =
                                loginWithGoogleResponse.response
                                    as fb.UserCredential;

                            if (googleUserCredential
                                .additionalUserInfo!.isNewUser) {
                              String userName = await getUniqueUsername(
                                  capitalizeWords(
                                      googleUserCredential.user!.displayName!));
                              String? fcmToken =
                                  await FirebaseMessaging.instance.getToken();
                              await userDataController.createUser(
                                  user: User(
                                      fcmToken: fcmToken!,
                                      verified: false,
                                      name: capitalizeWords(googleUserCredential
                                          .user!.displayName!),
                                      email: googleUserCredential.user!.email!,
                                      following: [],
                                      followers: [],
                                      posts: [],
                                      id: googleUserCredential.user!.uid,
                                      username: userName,
                                      stories: [],
                                      blocked: [],
                                      coverPicture: "",
                                      account_type: ACCOUNT_TYPE.PUBLIC));
                            } else {
                              await userDataController.setUser(
                                  userID: googleUserCredential.user!.uid);
                            }

                            await prefs.setBool(Pref.login_pref, true);
                            await prefs.setString(
                                Pref.user_id, googleUserCredential.user!.uid);

                            Get.showSnackbar(GetSnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.green,
                              borderRadius: 5,
                              title: "Login Success",
                              message: userDataController.user!.name,
                            ));
                            Get.offAllNamed(AppRoutes.homeNavigationScreen,
                                parameters: {'screenIndex': '0'});
                          } else {
                            Get.showSnackbar(GetSnackBar(
                              backgroundColor: CustomColor.errorColor,
                              borderRadius: 5,
                              title: "Login Failed",
                              duration: const Duration(seconds: 2),
                              message: loginWithGoogleResponse.response.message
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
