import 'dart:io';

import 'package:messenger/repositories/auth/auth.dart';

abstract interface class IStorageService {
  IStorageService({required IAuthService auth});
  Future<void> uploadAvatar(File image, String filename);
  Future<void> deleteAvatar(String filename);
}
