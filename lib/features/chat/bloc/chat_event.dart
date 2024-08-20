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
  const ChatSendMessageEvent({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
