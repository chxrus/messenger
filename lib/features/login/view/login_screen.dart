import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/router/router.dart';

import '../../../ui/ui.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.login,
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).loginTitle,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 36),
              CustomTextField(
                label: S.of(context).email,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: S.of(context).password,
              ),
              const SizedBox(height: 36),
              CustomButton(
                onPressed: () {},
                label: S.of(context).loginButton,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => GetIt.I<AppRouter>().pushNamed('/register'),
                child: Text(S.of(context).notRegistered),
              )
            ],
          ),
        ),
      ),
    );
  }
}
