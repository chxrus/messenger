import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/chat/bloc/chat_bloc.dart';
import 'package:messenger/features/chat/widgets/widgets.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:messenger/repositories/chat/abstract_chat_service.dart';
import 'package:messenger/repositories/chat/models/user_model.dart';
import 'package:messenger/router/router.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLastMessage() {
    final offset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = ChatBloc(
      chatService: GetIt.I<AbstractChatService>(),
      authService: GetIt.I<AbstractAuthService>(),
      anotherUserModel: widget.userModel,
    )..add(const ChatLoadEvent());
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => chatBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => GetIt.I<AppRouter>().maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(widget.userModel.email),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  bloc: chatBloc,
                  builder: (context, state) {
                    final messageList =
                        context.select((ChatBloc bloc) => bloc.messageList);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        controller: _scrollController,
                        children: messageList
                            .map(
                              (messageModel) => MessageTile(
                                messageModel: messageModel,
                                isCurrentUser: messageModel.senderID ==
                                    GetIt.I<AbstractAuthService>()
                                        .currentUser
                                        ?.uid,
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 16, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: S.of(context).writeMessage,
                          border: InputBorder.none,
                        ),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.colorScheme.onSurface),
                        controller: _messageController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: theme.colorScheme.primary,
                      ),
                      iconSize: 32,
                      onPressed: () async {
                        if (_messageController.text.isEmpty) {
                          return;
                        }
                        final completer = Completer();
                        chatBloc.add(
                          ChatSendMessageEvent(
                              message: _messageController.text,
                              completer: completer),
                        );
                        _messageController.clear();
                        await completer.future;
                        setState(() {});
                        _scrollToLastMessage();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
