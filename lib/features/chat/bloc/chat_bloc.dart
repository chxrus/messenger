import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:messenger/repositories/chat/abstract_chat_service.dart';
import 'package:messenger/repositories/chat/models/message_model.dart';
import 'package:messenger/repositories/chat/models/user_model.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required chatService,
    required authService,
    required anotherUserModel,
  })  : _chatService = chatService,
        _authService = authService,
        _anotherUserModel = anotherUserModel,
        super(ChatInitial()) {
    on<ChatLoadEvent>(_chatLoading);
    on<ChatSendMessageEvent>(_sendMessage);
  }

  FutureOr<void> _chatLoading(event, emit) async {
    try {
      emit(ChatLoadingState());
      final stream = _chatService.getMessagesStream(
          _authService.currentUser!.uid, _anotherUserModel.uid);
      await for (final messages in stream) {
        _messagesList = messages.docs
            .map((userData) =>
                MessageModel.fromMap(userData.data() as Map<String, dynamic>))
            .toList();
        emit(ChatLoadedState(messages: _messagesList));
      }
    } catch (e, st) {
      emit(ChatLoadingFailureState(exception: e));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  FutureOr<void> _sendMessage(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      await _chatService.sendMessage(
        _anotherUserModel.uid,
        event.message,
      );
    } catch (e, st) {
      emit(ChatSendingFailureState(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  final AbstractChatService _chatService;
  final AbstractAuthService _authService;
  final UserModel _anotherUserModel;
  List<MessageModel> _messagesList = [];

  List<MessageModel> get messageList => _messagesList;
}
