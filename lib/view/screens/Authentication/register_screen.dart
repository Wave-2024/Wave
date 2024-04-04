import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:wave/view/reusable_components/auth_textfield.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Create New Account",
                style: TextStyle(
                    fontFamily: poppins,
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
                    controller: nameController,
                    label: "Name",
                    visible: true,
                    prefixIcon: const Icon(Icons.mail),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Error1";
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
                    controller: emailController,
                    label: "Email",
                    visible: true,
                    prefixIcon: const Icon(Icons.mail),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Error1";
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
                    controller: passwordController,
                    label: "Password",
                    visible: false,
                    prefixIcon: const Icon(Icons.mail),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Error1";
                      }
                      return null;
                    }),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer2<AuthScreenController, UserController>(
                  builder: (context, authController, userController, child) {
                    return MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      height: 50,
                      onPressed: () async {
                        res.Response registrationResponse =
                            await authController.startRegistrationProcess(
                                email: emailController.text,
                                password: passwordController.text,
                                firebaseAuth: FirebaseAuth.instance);
                        if (registrationResponse.responseStatus) {
                          UserCredential userCredential =
                              registrationResponse.response as UserCredential;
                          await userController.setUser(
                              userID: userCredential.user!.uid);
                          Get.showSnackbar(GetSnackBar(
                            backgroundColor: Colors.green,
                            borderRadius: 5,
                            message: userCredential.user!.email.toString(),
                          ));
                        } else {
                          Get.showSnackbar(GetSnackBar(
                            backgroundColor: errorColor,
                            borderRadius: 5,
                            message: registrationResponse.response.message
                                .toString(),
                          ));
                        }
                      },
                      color: primaryButtonColor,
                      child: (authController.registerState == REGISTER.IDLE)
                          ? Text(
                              "Register",
                              style: TextStyle(
                                  fontFamily: poppins,
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
                        "Sign up with Google",
                        style: TextStyle(
                            fontFamily: poppins,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
