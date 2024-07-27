import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 1),
            color: Colors.black12,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: theme.colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
