part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoadingState extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoadedState extends ChatState {
  const ChatLoadedState({
    required this.messages,
  });

  final List<MessageModel> messages;

  @override
  List<Object?> get props => [messages];
}

final class ChatLoadingFailureState extends ChatState {
  const ChatLoadingFailureState({this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [];
}

final class ChatSendingFailureState extends ChatState {
  const ChatSendingFailureState({this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [];
}

final class ChatSentMessageState extends ChatState {
  const ChatSentMessageState({this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [];
}
