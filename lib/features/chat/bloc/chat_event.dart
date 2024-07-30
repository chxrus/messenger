part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class ChatLoadEvent extends ChatEvent {
  const ChatLoadEvent();

  @override
  List<Object?> get props => [];
}

final class ChatSendMessageEvent extends ChatEvent {
  const ChatSendMessageEvent({required this.message, this.completer});

  final String message;
  final Completer? completer;

  @override
  List<Object?> get props => [message, completer];
}
