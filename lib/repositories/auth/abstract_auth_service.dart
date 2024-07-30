import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AbstractAuthService {
  User? get currentUser;
  bool get isLoggedIn;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password);

  Future<void> signOut();
}
