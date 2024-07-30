import 'package:flutter/material.dart';
import 'package:messenger/repositories/chat/models/message_model.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
      {super.key, required this.messageModel, required this.isCurrentUser});

  final MessageModel messageModel;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              messageModel.message,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isCurrentUser
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          Padding(
            padding: isCurrentUser
                ? const EdgeInsets.only(top: 4, right: 4)
                : const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              _formattedTime(),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formattedTime() {
    String hours = messageModel.timestamp.toDate().hour.toString();
    String minutes = messageModel.timestamp.toDate().minute.toString();
    if (hours.length == 1) {
      hours = "0$hours";
    }
    if (minutes.length == 1) {
      minutes = "0$minutes";
    }
    return "$hours:$minutes";
  }
}
