import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/chat/models/user_model.dart';
import 'package:messenger/router/router.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      highlightColor: theme.colorScheme.surfaceContainerLow,
      splashColor: Colors.transparent,
      onTap: () => GetIt.I<AppRouter>().push(ChatRoute(userModel: userModel)),
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 36,
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userModel.email,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
