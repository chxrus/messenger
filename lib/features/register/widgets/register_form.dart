import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/register/cubit/register_cubit.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/router/router.dart';
import 'package:messenger/ui/ui.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? S.of(context).signUpSuccess,
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
                  content:
                      Text(state.errorMessage ?? S.of(context).signUpError)),
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
                const SizedBox(height: 64),
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
                const _NameTextField(),
                const SizedBox(height: 16),
                const _EmailTextField(),
                const SizedBox(height: 16),
                const _PasswordTextField(),
                const SizedBox(height: 16),
                const _ConfirmedPasswordTextField(),
                const SizedBox(height: 32),
                const _RegisterButton(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => GetIt.I<AppRouter>().replaceNamed('/'),
                  child: Text(S.of(context).alreadyRegistered),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : CustomButton(
                onPressed: state.isValid
                    ? () => context
                        .read<RegisterCubit>()
                        .signUpWithEmailAndPassword()
                    : null,
                label: S.of(context).registerButton,
              );
      },
    );
  }
}

class _ConfirmedPasswordTextField extends StatelessWidget {
  const _ConfirmedPasswordTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).confirmPassword,
          onChanged: (value) =>
              context.read<RegisterCubit>().confirmedPasswordChanged(value),
          isObscure: true,
          errorText: state.confirmedPassword.displayError != null
              ? S.of(context).invalidPassword
              : null,
        );
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).password,
          onChanged: (value) =>
              context.read<RegisterCubit>().passwordChanged(value),
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
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).email,
          onChanged: (value) =>
              context.read<RegisterCubit>().emailChanged(value),
          keyboardType: TextInputType.emailAddress,
          errorText: state.email.displayError != null
              ? S.of(context).invalidEmail
              : null,
        );
      },
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return CustomTextField(
          label: S.of(context).name,
          onChanged: (value) =>
              context.read<RegisterCubit>().nameChanged(value),
          keyboardType: TextInputType.name,
          errorText: state.name.displayError != null
              ? S.of(context).invalidName
              : null,
        );
      },
    );
  }
}
