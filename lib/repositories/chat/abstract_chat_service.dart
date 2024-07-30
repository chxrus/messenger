import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AbstractChatService {
  Stream<List<Map<String, dynamic>>> getUsersStream();
  Future<void> sendMessage(String receiverID, String message);
  Stream<QuerySnapshot> getMessagesStream(String userID, String otherUserID);
}
