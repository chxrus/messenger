import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';
import 'package:messenger/router/router.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required IAuthService authRepository})
      : _authRepository = authRepository,
        super(
          authRepository.currentUser.isEmpty
              ? const AuthState.unauthenticated()
              : AuthState.authenticated(authRepository.currentUser),
        ) {
    on<_AuthChangeUserEvent>(_authChangeUser);
    on<AuthSignOutEvent>(_authSignOut);

    _userSubscription = _authRepository.user.listen(
      (user) {
        add(_AuthChangeUserEvent(user));
      },
    );
  }

  late final StreamSubscription<UserModel> _userSubscription;
  final IAuthService _authRepository;

  FutureOr<void> _authChangeUser(
      _AuthChangeUserEvent event, Emitter<AuthState> emit) {
    if (event.user.isEmpty) {
      GetIt.I<Talker>().info('_authChangeUser: emptyUser -> unauthenticate');
      emit(const AuthState.unauthenticated());
    } else {
      GetIt.I<Talker>().info('_authChangeUser: notEmptyUser -> authenticate');
      GetIt.I<AppRouter>().pushNamed('/messages');

      emit(AuthState.authenticated(event.user));
    }
  }

  FutureOr<void> _authSignOut(
      AuthSignOutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
