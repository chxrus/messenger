part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginSubmitSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

final class LoginSubmitFailureState extends LoginState {
  final String message;

  const LoginSubmitFailureState({required this.message});

  @override
  List<Object> get props => [];
}
