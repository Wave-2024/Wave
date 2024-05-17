import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Future<void> signOut() async {
    await _auth.signOut();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<dynamic> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential? userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<dynamic> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  // Future<dynamic> googleLogin() async {
  //   try {
  //     final gUser = await GoogleSignIn().signIn();
  //     if (gUser != null) {
  //       final gauth = await gUser.authentication;
  //       final gCred = GoogleAuthProvider.credential(
  //           accessToken: gauth.accessToken, idToken: gauth.idToken);
  //       final UserCredential userCredential =
  //       await auth.signInWithCredential(gCred);
  //       return userCredential;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
