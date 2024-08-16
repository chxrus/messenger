import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure([super.value = ''])
      : _password = null,
        super.pure();

  const ConfirmedPassword.dirty([super.value = '', this._password = ''])
      : super.dirty();

  final String? _password;

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return value == _password && _passwordRegExp.hasMatch(value)
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
