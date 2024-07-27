import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authService) : super(RegisterInitial()) {
    on<RegisterSubmitEvent>((event, emit) async {
      try {
        await _authService.signUpWithEmailAndPassword(
            event.email, event.password);
        emit(RegisterSubmitSuccessState());
        emit(RegisterInitial());
      } catch (e, st) {
        emit(RegisterSubmitFailureState(message: e.toString()));
        emit(RegisterInitial());
        GetIt.I<Talker>().handle(e, st);
      }
    });
  }

  final AbstractAuthService _authService;
}
