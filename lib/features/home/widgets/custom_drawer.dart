import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/bloc/theme/theme_cubit.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:messenger/router/router.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void signOut(BuildContext context) {
    GetIt.I<AbstractAuthService>().signOut();
    GetIt.I<AppRouter>().popUntilRoot();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = context.read<ThemeCubit>().state.isDarkTheme;
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.surfaceContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 64,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    GetIt.I<AbstractAuthService>()
                            .currentUser
                            ?.email
                            .toString() ??
                        S.of(context).loadingError,
                    style: theme.textTheme.labelMedium,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Switch(
                    activeColor: theme.colorScheme.primary,
                    value: isDarkTheme,
                    onChanged: (value) {
                      setState(() {
                        context.read<ThemeCubit>().setDarkTheme(value);
                      });
                    }),
                const SizedBox(width: 8),
                Text(
                  S.of(context).darkTheme,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          ListTile(
            title: Text(
              S.of(context).logOut,
              style: theme.textTheme.labelMedium,
            ),
            leading: const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Icon(Icons.logout),
            ),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
