import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/storage/i_storage_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

final class StorageService implements IStorageService {
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> uploadAvatar(File image, String filename) async {
    try {
      final ref = _storage.ref().child('Avatars').child(filename);
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).update({
        'photoURL': downloadUrl,
      });
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  Future<void> deleteAvatar(String filename) async {
    try {
      await _storage.ref().child('Avatars').child(filename).delete();
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'photoURL': FieldValue.delete()});
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }
}
