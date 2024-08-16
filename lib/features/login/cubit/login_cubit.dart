import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/auth/models/models.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final IAuthService _authRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.email,
          email,
          state.password,
        ])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.email,
          password,
        ])));
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!state.isValid) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.signInWithEmailAndPassword(
        state.email.value,
        state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithEmailAndPasswordException catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, errorMessage: e.message));
    } catch (e, st) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
