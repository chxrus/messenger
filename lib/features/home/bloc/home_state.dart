part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loaded,
  failure,
}

final class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.users = const [],
  });

  final List<UserModel> users;
  final HomeStatus status;

  @override
  List<Object> get props => [status, users];
}
