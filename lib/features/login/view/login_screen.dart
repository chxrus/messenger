import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/login/cubit/login_cubit.dart';
import 'package:messenger/features/login/widgets/widgets.dart';
import 'package:messenger/repositories/auth/auth.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: BlocProvider(
            create: (context) => LoginCubit(context.read<IAuthService>()),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
