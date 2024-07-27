part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

final class RegisterSubmitSuccessState extends RegisterState {
  @override
  List<Object> get props => [];
}

final class RegisterSubmitFailureState extends RegisterState {
  final String message;

  const RegisterSubmitFailureState({required this.message});

  @override
  List<Object> get props => [];
}
