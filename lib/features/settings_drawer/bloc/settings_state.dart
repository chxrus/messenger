part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.url,
  });

  final String? url;

  @override
  List<Object?> get props => [url];
}
