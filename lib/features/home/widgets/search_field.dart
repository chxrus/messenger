import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/home/bloc/home_bloc.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/ui/ui.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
        child: CustomTextField(
          controller: _controller,
          onChanged: (value) {
            context.read<HomeBloc>().queryChanged(value);
            setState(() {});
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
            fillColor: theme.colorScheme.surfaceContainerHighest,
            filled: true,
            hintText: S.of(context).search,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _controller.clear();
                      context.read<HomeBloc>().queryChanged('');
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                  ),
          ),
        ),
      ),
    );
  }
}
