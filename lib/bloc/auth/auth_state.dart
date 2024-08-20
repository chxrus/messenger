part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

final class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    UserModel user = UserModel.empty,
  }) : _user = user;

  const AuthState.authenticated(UserModel user)
      : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(
          status: AuthStatus.unauthenticated,
        );

  final AuthStatus status;
  final UserModel _user;

  UserModel get currentUser => _user;

  @override
  List<Object?> get props => [_user, status];
}
