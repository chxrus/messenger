import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/register/bloc/register_bloc.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/router/router.dart';
import 'package:messenger/ui/ui.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _registerBloc = RegisterBloc(GetIt.I<AbstractAuthService>());

  void register() {
    if (_passwordController.text != _confirmPasswordController.text) {}
    _registerBloc.add(
      RegisterSubmitEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocListener<RegisterBloc, RegisterState>(
          bloc: _registerBloc,
          listener: (context, state) {
            if (state is RegisterSubmitSuccessState) {
              GetIt.I<AppRouter>().pushNamed('/messages');
            }

            if (state is RegisterSubmitFailureState) {
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 128),
                    const Icon(
                      Icons.person,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).registerTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: S.of(context).email,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: S.of(context).newPassword,
                      isObscure: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: S.of(context).confirmPassword,
                      isObscure: true,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onPressed: register,
                      label: S.of(context).registerButton,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => GetIt.I<AppRouter>().replaceNamed('/'),
                      child: Text(S.of(context).alreadyRegistered),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
