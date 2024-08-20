import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/auth/models/models.dart';
import 'package:messenger/repositories/chat/chat.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
      {required IChatService chatService, required IAuthService authService})
      : _chatService = chatService,
        _authService = authService,
        super(const HomeState(status: HomeStatus.initial)) {
    on<_HomeLoadEvent>(_homeLoad);
    on<HomeRefreshEvent>(_homeRefresh);
    on<_HomeErrorEvent>(_homeError);
    _init();
  }

  final IChatService _chatService;
  final IAuthService _authService;
  late final BehaviorSubject<String> _textController;
  late final StreamSubscription<List<UserModel>> _usersSubscription;
  late String _lastQuery;

  void _init() {
    _textController = BehaviorSubject<String>()
      ..sink
      ..add(_lastQuery = '');

    _usersSubscription = Rx.combineLatest2(
      _textController.stream
          .throttleTime(const Duration(seconds: 1), trailing: true),
      _chatService.getUsersStream().debounceTime(const Duration(seconds: 2)),
      (String query, List<UserModel> users) {
        try {
          return users.where((user) {
            _lastQuery = query;
            final formattedQuery = query.trim().toLowerCase();
            final isNotCurrentUser = user != _authService.currentUser;
            final isSearchEmpty = formattedQuery.isEmpty;
            final satisfiesQuery =
                (user.email?.contains(formattedQuery) ?? false) ||
                    (user.name?.contains(formattedQuery) ?? false);
            return isNotCurrentUser && (isSearchEmpty || satisfiesQuery);
          }).toList();
        } catch (_) {
          rethrow;
        }
      },
    ).listen((users) {
      add(_HomeLoadEvent(users: users));
    }, onError: (error) {
      add(const _HomeErrorEvent());
    });
  }

  void _homeLoad(_HomeLoadEvent event, Emitter<HomeState> emit) {
    emit(HomeState(status: HomeStatus.loaded, users: event.users));
  }

  void _homeError(_HomeErrorEvent event, Emitter<HomeState> emit) {
    emit(const HomeState(status: HomeStatus.failure));
  }

  void queryChanged(String query) {
    _textController.sink.add(query);
  }

  void _homeRefresh(HomeRefreshEvent event, Emitter<HomeState> emit) {
    _textController.sink.add(_lastQuery);
  }

  @override
  Future<void> close() {
    _textController.close();
    _usersSubscription.cancel();
    return super.close();
  }
}
