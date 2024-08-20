import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/bloc/theme/theme_cubit.dart';
import 'package:messenger/features/settings_drawer/bloc/settings_bloc.dart';
import 'package:messenger/features/settings_drawer/widgets/widgets.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/storage/i_storage_service.dart';
import 'package:messenger/router/router.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({
    super.key,
  });

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = context.watch<ThemeCubit>().state.isDarkTheme;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SettingsBloc(
        auth: context.read<IAuthService>(),
        storage: context.read<IStorageService>(),
      ),
      child: Drawer(
        backgroundColor: theme.colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DrawerHeader(
              child: ProfileHeader(),
            ),
            SettingsSwitch(
              title: S.of(context).darkTheme,
              value: isDarkTheme,
              onChanged: context.read<ThemeCubit>().setDarkTheme,
            ),
            const Spacer(),
            SettingsButton(
              title: S.of(context).logOut,
              icon: const Icon(Icons.logout),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  void _signOut() {
    context.read<AuthBloc>().add(AuthSignOutEvent());
    GetIt.I<AppRouter>().replaceNamed('/login');
  }
}
