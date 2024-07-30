import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/features/home/bloc/home_bloc.dart';
import 'package:messenger/features/home/widgets/user_tile.dart';
import 'package:messenger/features/home/widgets/widgets.dart';
import 'package:messenger/generated/l10n.dart';
import 'package:messenger/repositories/auth/abstract_auth_service.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:messenger/repositories/chat/models/user_model.dart';
import 'package:messenger/ui/ui.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = HomeBloc(
    GetIt.I<AbstractChatService>(),
    GetIt.I<AbstractAuthService>(),
  );

  @override
  void initState() {
    super.initState();
    _homeBloc.add(HomeLoadEvent());
  }

  Future<void> _refresh() async {
    _homeBloc.add(HomeLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: S.of(context).homeTitle),
            BlocBuilder<HomeBloc, HomeState>(
              bloc: _homeBloc,
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return SliverList.separated(
                    itemCount: state.users?.length ?? 0,
                    separatorBuilder: (context, index) => Divider(
                      color: theme.colorScheme.onSurface,
                      endIndent: 16,
                      height: 1,
                      indent: 16,
                      thickness: .5,
                    ),
                    itemBuilder: (context, index) => UserTile(
                      userModel: UserModel.fromMap(state.users![index]),
                    ),
                  );
                }

                if (state is HomeLoadingFailureState) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(S.of(context).loadingError)),
                  );
                }

                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
