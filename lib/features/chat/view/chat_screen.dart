import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/features/chat/bloc/chat_bloc.dart';
import 'package:messenger/features/chat/widgets/chat_input_field.dart';
import 'package:messenger/features/chat/widgets/chat_list_view.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/models/user_model.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:messenger/router/router.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ChatBloc(
          chatService: context.read<IChatService>(),
          user: context.read<AuthBloc>().state.currentUser,
          anotherUser: user)
        ..add(const ChatLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => appRouter.maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              user.photoURL != null
                  ? SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          user.photoURL!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      height: 40,
                      'assets/svg/person.svg',
                      colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary, BlendMode.srcIn),
                    ),
              const SizedBox(width: 12),
              Text(
                user.name ?? user.email ?? S.of(context).loadingError,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.appBarTheme.titleTextStyle?.color,
                ),
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: const Stack(children: [
            Column(
              children: <Widget>[
                ChatListView(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatInputField(),
            ),
          ]),
        ),
      ),
    );
  }
}
