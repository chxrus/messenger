import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/app/app_initializer.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/bloc/theme/theme_cubit.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/router/router.dart';
import 'package:messenger/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();
    final talker = GetIt.I<Talker>();

    return AppInitializer(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.currentUser.isNotEmpty) {
                appRouter.replaceNamed('/messages');
              } else {
                appRouter.replaceNamed('/login');
              }
            },
            child: MaterialApp.router(
              title: 'Messenger',
              theme: state.isDarkTheme ? darkTheme : lightTheme,
              routerConfig: appRouter.config(
                navigatorObservers: () => [
                  TalkerRouteObserver(talker),
                ],
              ),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const <Locale>[
                Locale('en'),
                Locale('ru'),
              ],
            ),
          );
        },
      ),
    );
  }
}
