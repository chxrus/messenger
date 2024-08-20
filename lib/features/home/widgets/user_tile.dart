import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';
import 'package:messenger/router/router.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.anotherUser,
  });

  final UserModel anotherUser;

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();
    final theme = Theme.of(context);

    return InkWell(
      highlightColor: theme.colorScheme.surfaceContainerLow,
      splashColor: Colors.transparent,
      onTap: () => appRouter.push(ChatRoute(user: anotherUser)),
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            anotherUser.photoURL != null
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        anotherUser.photoURL!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    height: 50,
                    'assets/svg/person.svg',
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary, BlendMode.srcIn),
                  ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anotherUser.name ?? S.of(context).loadingError,
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  anotherUser.email ?? S.of(context).loadingError,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
