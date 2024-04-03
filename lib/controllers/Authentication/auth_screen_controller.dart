import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/services/auth_services.dart';
import 'package:wave/utils/enums.dart';

class AuthScreenController extends ChangeNotifier {
  LOGIN loginState = LOGIN.IDLE;
  REGISTER registerState = REGISTER.IDLE;

  Future<Response> startLoginProcess(
      {required String email,
      required String password,
      required FirebaseAuth firebaseAuth}) async {
    loginState = LOGIN.LOGGING_IN;
    await Future.delayed(Duration.zero);
    notifyListeners();

    var auth = AuthService(firebaseAuth);
    var authResponse = await auth.signIn(email: email, password: password);
    // Successful sign in
    if (authResponse.runtimeType == UserCredential) {
      loginState = LOGIN.IDLE;
      notifyListeners();
      return Response(responseStatus: true, response: authResponse);
    }
    // Sign in failed
    else {
      loginState = LOGIN.IDLE;
      notifyListeners();

      return Response(responseStatus: false, response: authResponse);
    }
  }

  Future<Response> startRegistrationProcess(
      {required String email,
      required String password,
      required FirebaseAuth firebaseAuth}) async {
    registerState = REGISTER.CREATING;
    await Future.delayed(Duration.zero);
    var auth = AuthService(firebaseAuth);
    var authResponse = await auth.signUp(email: email, password: password);
    // Successful sign up
    if (authResponse.runtimeType == UserCredential) {
      registerState = REGISTER.IDLE;
      return Response(responseStatus: true, response: authResponse);
    }
    // Sign up failed
    else {
      registerState = REGISTER.IDLE;

      return Response(responseStatus: false, response: authResponse);
    }
  }
}
