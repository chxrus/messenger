import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isObscure = false,
    this.controller,
  });

  final String label;
  final bool isObscure;
  final TextEditingController? controller;

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
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: theme.textTheme.labelMedium,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          fillColor: theme.cardColor,
          labelText: label,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(.75),
          ),
          filled: true,
        ),
      ),
    );
  }
}
