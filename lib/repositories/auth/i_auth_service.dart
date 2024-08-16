import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';

abstract interface class IAuthService {
  UserModel get currentUser;
  Stream<UserModel> get user;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> signUpWithEmailAndPassword(
      String name, String email, String password);

  Future<void> signOut();
}
