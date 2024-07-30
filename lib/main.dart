import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/app.dart';
import 'package:messenger/firebase_options.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:messenger/router/router.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final talker = TalkerFlutter.init();

    GetIt.I.registerSingleton(talker);
    GetIt.I.registerLazySingleton<AppRouter>(() => AppRouter());
    GetIt.I.registerLazySingleton<AbstractAuthService>(() => AuthService());
    GetIt.I.registerLazySingleton<AbstractChatService>(() => ChatService());

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: false,
      ),
    );
    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    runApp(const App());
  }, (error, stack) => GetIt.I<Talker>().handle(error, stack));
}
