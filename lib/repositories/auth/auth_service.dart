import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/repositories/auth/i_auth_service.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';

final class AuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel _currentUser = UserModel.empty;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordException.fromCode(e.code);
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'uid': userCredential.user!.uid,
        'email': email,
        'password': password
      });

      _currentUser = _currentUser.copyWith(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordException.fromCode(e.code);
    }
  }

  @override
  UserModel get currentUser => _currentUser;

  @override
  Stream<UserModel> get user => _auth.authStateChanges().transform(
        StreamTransformer<User?, UserModel>.fromHandlers(
          handleData: (User? user, EventSink<UserModel> sink) async {
            _currentUser = UserModel.empty;

            if (user == null) {
              sink.add(_currentUser);
              return;
            }

            final doc =
                await _firestore.collection('Users').doc(user.uid).get();

            if (doc.data() == null) {
              _currentUser = _currentUser.copyWith(
                id: user.uid,
                email: user.email,
              );
              sink.add(_currentUser);
              return;
            }

            _currentUser = UserModel.fromMap(doc.data()!);
            sink.add(_currentUser);
          },
        ),
      );

  @override
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}

class SignInWithEmailAndPasswordException {
  const SignInWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignInWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordException(
          'Incorrect password, please try again.',
        );
      case 'too-many-requests':
        return const SignInWithEmailAndPasswordException(
          'Too many requests, please try again later.',
        );
      default:
        return const SignInWithEmailAndPasswordException();
    }
  }

  final String message;
}

class SignUpWithEmailAndPasswordException {
  const SignUpWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordException(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordException(
          'Operation is not allowed. Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordException(
          'Please enter a stronger password.',
        );
      case 'too-many-requests':
        return const SignUpWithEmailAndPasswordException(
          'Too many requests, please try again later.',
        );
      default:
        return const SignUpWithEmailAndPasswordException();
    }
  }

  final String message;
}
