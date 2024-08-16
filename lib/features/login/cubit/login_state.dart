part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final bool isValid;
  final String? errorMessage;
  final FormzSubmissionStatus status;

  @override
  List<Object?> get props => [email, password, isValid, errorMessage, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    bool? isValid,
    String? errorMessage,
    FormzSubmissionStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
