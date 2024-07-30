import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/login/bloc/login_bloc.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/router/router.dart';
import 'package:messenger/ui/ui.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginBloc = LoginBloc(GetIt.I<AbstractAuthService>())
    ..add(LoginInitialEvent());

  void login() {
    _loginBloc.add(
      LoginSubmitEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocListener<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state is LoginSubmitSuccessState) {
              GetIt.I<AppRouter>().pushNamed('/messages');
            }

            if (state is LoginSubmitFailureState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      state.message,
                      style: theme.textTheme.labelMedium,
                    ),
                  );
                },
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 128),
                  const Icon(
                    Icons.login,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).loginTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: S.of(context).email,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: S.of(context).password,
                    controller: _passwordController,
                    isObscure: true,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    onPressed: login,
                    label: S.of(context).loginButton,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        GetIt.I<AppRouter>().replaceNamed('/register'),
                    child: Text(S.of(context).notRegistered),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
