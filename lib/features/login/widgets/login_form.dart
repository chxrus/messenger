import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/login/cubit/login_cubit.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/router/router.dart';
import 'package:messenger/ui/ui.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();
    final theme = Theme.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).signInSuccess,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
        }

        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? S.of(context).signInError,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onError,
                  ),
                ),
                backgroundColor: theme.colorScheme.error,
              ),
            );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
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
              const _EmailTextField(),
              const SizedBox(height: 16),
              const _PasswordTextField(),
              const SizedBox(height: 32),
              const _LoginButton(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => appRouter.replaceNamed('/register'),
                child: Text(S.of(context).notRegistered),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : CustomButton(
                onPressed: state.isValid
                    ? () =>
                        context.read<LoginCubit>().signInWithEmailAndPassword()
                    : null,
                label: S.of(context).loginButton,
              );
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).password,
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          isObscure: true,
          errorText: state.password.displayError != null
              ? S.of(context).invalidPassword
              : null,
        );
      },
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).email,
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
          errorText: state.email.displayError != null
              ? S.of(context).invalidEmail
              : null,
        );
      },
    );
  }
}
