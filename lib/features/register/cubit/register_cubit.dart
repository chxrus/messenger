import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/auth/models/models.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterState());

  final IAuthService _authRepository;

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
        name: name,
        isValid: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ])));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.name,
          email,
          state.password,
          state.confirmedPassword,
        ])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      state.confirmedPassword.value,
      value,
    );
    emit(state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.name,
          state.email,
          password,
          confirmedPassword,
        ])));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      value,
      state.password.value,
    );
    emit(state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.name,
          state.email,
          state.password,
          confirmedPassword,
        ])));
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (!state.isValid) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.signUpWithEmailAndPassword(
        state.name.value,
        state.email.value,
        state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordException catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, errorMessage: e.message));
    } catch (e, st) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
