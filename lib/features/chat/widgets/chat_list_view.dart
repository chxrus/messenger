import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:messenger/features/chat/bloc/chat_bloc.dart';
import 'package:messenger/features/chat/widgets/message_tile.dart';
import 'package:messenger/repositories/auth/i_auth_service.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({
    super.key,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final StreamSubscription<bool> _keyboardSubscription;
  final ScrollController _scrollController = ScrollController();
  bool _isEnoughHigh = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    _keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((isVisible) {
      _keyboardVisible = isVisible;
      setState(() {});
    });
    _scrollController.addListener(() {
      _isEnoughHigh = _scrollController.offset > 400;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLastMessage() {
    final offset = _scrollController.position.minScrollExtent;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatSendedMessageState) {
            _scrollToLastMessage();
          }
        },
        builder: (context, state) {
          return BlocBuilder<ChatBloc, ChatState>(
            bloc: BlocProvider.of<ChatBloc>(context),
            builder: (context, state) {
              final messageList =
                  context.select((ChatBloc bloc) => bloc.messageList);
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      const SizedBox(height: 64),
                      ...messageList.reversed.map(
                        (messageModel) => MessageTile(
                          messageModel: messageModel,
                          isCurrentUser: messageModel.senderID ==
                              context.read<IAuthService>().currentUser.id,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                if (_isEnoughHigh && !_keyboardVisible)
                  Align(
                    alignment:
                        Alignment.bottomRight.add(const Alignment(-.1, -.275)),
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: theme.colorScheme.primary,
                      onPressed: _scrollToLastMessage,
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                  ),
              ]);
            },
          );
        },
      ),
    );
  }
}
