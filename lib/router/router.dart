import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/chat/view/chat_screen.dart';
import 'package:messenger/features/home/view/home_screen.dart';
import 'package:messenger/features/login/view/login_screen.dart';
import 'package:messenger/features/register/view/register_screen.dart';
import 'package:messenger/repositories/chat/models/user_model.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: LoginRoute.page,
          path: '/login',
          initial: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: RegisterRoute.page,
          path: '/register',
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        AutoRoute(page: HomeRoute.page, path: '/messages'),
        CustomRoute(
          page: ChatRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
          durationInMilliseconds: 125,
          reverseDurationInMilliseconds: 125,
        ),
      ];
}
