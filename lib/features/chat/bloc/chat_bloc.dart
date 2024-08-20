import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:messenger/repositories/chat/models/message_model.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required chatService,
    required UserModel user,
    required UserModel anotherUser,
  })  : _user = user,
        _anotherUser = anotherUser,
        _chatService = chatService,
        super(ChatInitial()) {
    on<ChatLoadEvent>(_chatLoading);
    on<ChatSendMessageEvent>(_sendMessage);
  }

  final IChatService _chatService;
  final UserModel _user;
  final UserModel _anotherUser;

  List<MessageModel> _messagesList = [];

  List<MessageModel> get messageList => _messagesList;

  FutureOr<void> _chatLoading(event, emit) async {
    try {
      emit(ChatLoadingState());
      final stream = _chatService.getMessagesStream(_user.id, _anotherUser.id);
      await for (final messages in stream) {
        _messagesList = messages;
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
        _anotherUser.id,
        event.message,
      );
      emit(const ChatSentMessageState());
    } catch (e, st) {
      emit(ChatSendingFailureState(exception: e));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
