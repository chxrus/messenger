part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Name name;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool isValid;
  final String? errorMessage;
  final FormzSubmissionStatus status;

  @override
  List<Object?> get props =>
      [name, email, password, isValid, errorMessage, status];

  RegisterState copyWith({
    Name? name,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? isValid,
    String? errorMessage,
    FormzSubmissionStatus? status,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
