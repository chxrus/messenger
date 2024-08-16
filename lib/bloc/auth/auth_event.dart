part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthSignOutEvent extends AuthEvent {}

final class _AuthChangeUserEvent extends AuthEvent {
  const _AuthChangeUserEvent(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}
