part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class AvatarUploadEvent extends SettingsEvent {
  const AvatarUploadEvent({
    required this.file,
  });

  final File file;

  @override
  List<Object> get props => [file];
}

class AvatarLoadEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class AvatarDeleteEvent extends SettingsEvent {
  @override
  List<Object> get props => [];
}
