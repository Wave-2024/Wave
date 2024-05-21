import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/services/auth_services.dart';
import 'package:wave/utils/constants/preferences.dart';
import 'package:wave/utils/enums.dart';

class AuthScreenController extends ChangeNotifier {
  LOGIN loginState = LOGIN.IDLE;
  REGISTER registerState = REGISTER.IDLE;
  bool _obscuredTextLogin = false;
  bool _obscuredTextReg = false;
  bool get obscuredTextLogin => _obscuredTextLogin;
  bool get obscuredTextReg => _obscuredTextReg;

  // Method to toggle password visibility for login screen
  void togglePasswordVisibilityLogin() {
    _obscuredTextLogin = !_obscuredTextLogin;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to toggle password visibility for registration screen
  void togglePasswordVisibilityReg() {
    _obscuredTextReg = !_obscuredTextReg;
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<CustomResponse> startLoginProcess(
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
      return CustomResponse(responseStatus: true, response: authResponse);
    }
    // Sign in failed
    else {
      loginState = LOGIN.IDLE;
      notifyListeners();

      return CustomResponse(responseStatus: false, response: authResponse);
    }
  }

  Future<CustomResponse> startRegistrationProcess(
      {required String email,
      required String password,
      required FirebaseAuth firebaseAuth}) async {
    registerState = REGISTER.CREATING;
    await Future.delayed(Duration.zero);
    notifyListeners();
    var auth = AuthService(firebaseAuth);
    var authResponse = await auth.signUp(email: email, password: password);
    // Successful sign up
    if (authResponse.runtimeType == UserCredential) {
      registerState = REGISTER.IDLE;
      notifyListeners();
      return CustomResponse(responseStatus: true, response: authResponse);
    }
    // Sign up failed
    else {
      registerState = REGISTER.IDLE;
      notifyListeners();
      return CustomResponse(responseStatus: false, response: authResponse);
    }
  }

  Future<void> signOut({required FirebaseAuth firebaseAuth}) async {
    var auth = AuthService(firebaseAuth);
    await auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Pref.login_pref, false);
    await prefs.setString(Pref.user_id, "");
  }

  Future<CustomResponse> loginWithGoogle(
      {required FirebaseAuth firebaseAuth}) async {
    var auth = AuthService(firebaseAuth);
    CustomResponse customResponse = await auth.signInWithGoogle();
    return customResponse;
  }
}
