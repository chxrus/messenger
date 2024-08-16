import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/register/cubit/register_cubit.dart';
import 'package:messenger/features/register/widgets/widgets.dart';
import 'package:messenger/repositories/auth/auth.dart';

@RoutePage()
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: BlocProvider(
            create: (context) => RegisterCubit(context.read<IAuthService>()),
            child: const RegisterForm(),
          ),
        ),
      ),
    );
  }
}
