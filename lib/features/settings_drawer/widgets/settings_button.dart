import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.labelMedium,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: icon,
      ),
      onTap: onTap,
    );
  }
}
