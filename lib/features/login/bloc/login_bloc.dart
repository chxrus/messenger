import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authService) : super(LoginInitial()) {
    on<LoginInitialEvent>((event, emit) {
      if (_authService.isLoggedIn) {
        emit(LoginSubmitSuccessState());
      }
    });

    on<LoginSubmitEvent>((event, emit) async {
      try {
        await _authService.signInWithEmailAndPassword(
            event.email, event.password);
        emit(LoginSubmitSuccessState());
        emit(LoginInitial());
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        emit(LoginSubmitFailureState(message: e.toString()));
        emit(LoginInitial());
      }
    });
  }

  final AbstractAuthService _authService;
}
