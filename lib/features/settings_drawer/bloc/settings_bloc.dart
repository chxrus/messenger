import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/auth/auth.dart';
import 'package:messenger/repositories/auth/i_auth_service.dart';
import 'package:messenger/repositories/storage/i_storage_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required IAuthService auth, required IStorageService storage})
      : _auth = auth,
        _storage = storage,
        super(const SettingsState()) {
    on<AvatarUploadEvent>(_avatarUpload);
    on<AvatarDeleteEvent>(_avatarDelete);
  }

  final IAuthService _auth;
  final IStorageService _storage;

  void _avatarUpload(
    AvatarUploadEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _storage.uploadAvatar(
        event.file,
        _auth.currentUser.id,
      );
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  void _avatarDelete(
    AvatarDeleteEvent event,
    Emitter<SettingsState> emit,
  ) {
    try {
      _storage.deleteAvatar(_auth.currentUser.id);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
