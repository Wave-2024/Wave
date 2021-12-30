import 'package:firebase_auth/firebase_auth.dart';

class authservice {
  // Create an instance of firebase authentication.
  final FirebaseAuth _auth;

  authservice(this._auth);
  //auth is an private property !!

  // ignore: non_constant_identifier_names

  Stream<User?> get austhStateChanges => _auth.authStateChanges();

//sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

//sign in with email and password  !!
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      print("email =$email");
      print("password=$password");
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "valid";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> changeDisplayName(String displayName) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      return user.updateDisplayName(displayName);
    } catch (error) {
      print(error);
    }
  }

  Future<String?> signUp(
      {required String email,
        String? displayName,
        required String password}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user!.updateDisplayName(displayName);
        value.user!.sendEmailVerification();
      });
      return "valid";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'ok';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}