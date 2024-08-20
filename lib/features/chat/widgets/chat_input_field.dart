import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/chat/bloc/chat_bloc.dart';
import 'package:messenger/generated/l10n.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _messageController = TextEditingController();
  bool _isMessageExist = false;

  @override
  void initState() {
    _messageController.addListener(() {
      _isMessageExist = _messageController.text.trim().isNotEmpty;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(32.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      padding:
          const EdgeInsets.symmetric(vertical: 2).copyWith(left: 16, right: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: S.of(context).writeMessage,
                hintStyle: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
              ),
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              controller: _messageController,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.send,
            ),
            iconSize: 32,
            disabledColor: theme.colorScheme.onSurfaceVariant,
            color: theme.colorScheme.primary,
            onPressed: _isMessageExist
                ? () async {
                    if (_messageController.text.isEmpty) {
                      return;
                    }
                    final chatBloc = context.read<ChatBloc>();
                    chatBloc.add(
                      ChatSendMessageEvent(message: _messageController.text),
                    );
                    _messageController.clear();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
