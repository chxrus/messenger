import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/repositories/auth/models/models.dart';

abstract interface class IChatService {
  Stream<List<UserModel>> getUsersStream();
  Future<void> sendMessage(String receiverID, String message);
  Stream<QuerySnapshot> getMessagesStream(String userID, String otherUserID);
}
