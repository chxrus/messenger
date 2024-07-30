import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/chat/abstract_chat_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._chatService, this._auth) : super(HomeInitial()) {
    on<HomeLoadEvent>((event, emit) async {
      try {
        final stream = _chatService.getUsersStream();
        emit(HomeLoadingState());

        await for (final users in stream) {
          emit(
            HomeLoadedState(
              users: users
                  .where((user) => user['email'] != _auth.currentUser?.email)
                  .toList(),
            ),
          );
        }
      } catch (e) {
        emit(HomeLoadingFailureState(exception: e));
        GetIt.I<Talker>().handle(e);
      }
    });
  }

  final AbstractChatService _chatService;
  final AbstractAuthService _auth;
}
