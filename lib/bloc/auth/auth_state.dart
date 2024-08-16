part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

final class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user = UserModel.empty,
  });

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
  final UserModel user;

  UserModel get currentUser => user;

  @override
  List<Object?> get props => [user, status];
}
