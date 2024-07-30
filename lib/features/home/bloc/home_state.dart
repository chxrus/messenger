part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoadedState extends HomeState {
  const HomeLoadedState({this.users});

  final List<Map<String, dynamic>>? users;
}

final class HomeLoadingFailureState extends HomeState {
  const HomeLoadingFailureState({this.exception});

  final Object? exception;
}
