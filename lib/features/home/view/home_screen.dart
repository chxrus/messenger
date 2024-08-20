import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/features/home/bloc/home_bloc.dart';
import 'package:messenger/features/home/widgets/widgets.dart';
import 'package:messenger/features/settings_drawer/settings_drawer.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/i_auth_service.dart';
import 'package:messenger/repositories/chat/chat.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (_) => HomeBloc(
          chatService: context.read<IChatService>(),
          authService: context.read<IAuthService>(),
        )..add(const HomeRefreshEvent()),
        child: Scaffold(
          drawer: const SettingsDrawer(),
          appBar: AppBar(
            title: Text(S.of(context).homeTitle),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: SearchField(),
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeRefreshEvent());
                  },
                  child: CustomScrollView(
                    slivers: [
                      if (state.status == HomeStatus.loaded)
                        SliverList.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) => UserTile(
                            anotherUser: state.users[index],
                          ),
                        )
                      else if (state.status == HomeStatus.failure)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(S.of(context).loadingError),
                          ),
                        )
                      else
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
