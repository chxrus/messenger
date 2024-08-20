import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/bloc/theme/theme_cubit.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:messenger/repositories/storage/storage.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthService>(
          create: (context) => AuthService(),
        ),
        RepositoryProvider<IChatService>(
          create: (context) => ChatService(),
        ),
        RepositoryProvider<IStorageService>(
          create: (context) => StorageService(),
        ),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => ThemeCubit(
            PlatformDispatcher.instance.platformBrightness == Brightness.dark,
          ),
        ),
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: context.read<IAuthService>()),
          lazy: false,
        ),
      ], child: child),
    );
  }
}
