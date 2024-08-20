part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class _HomeLoadEvent extends HomeEvent {
  const _HomeLoadEvent({
    required this.users,
  });

  final List<UserModel> users;

  @override
  List<Object> get props => [users];
}

class _HomeErrorEvent extends HomeEvent {
  const _HomeErrorEvent();
}

class HomeSearchEvent extends HomeEvent {
  const HomeSearchEvent({
    this.query = '',
  });

  final String query;

  @override
  List<Object> get props => [query];
}

class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();
}
