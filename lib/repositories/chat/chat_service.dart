import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/repositories/auth/models/models.dart';
import 'package:messenger/repositories/chat/i_chat_service.dart';
import 'package:messenger/repositories/chat/models/message_model.dart';

final class ChatService implements IChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<List<UserModel>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return UserModel.fromMap(user);
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  @override
  Stream<QuerySnapshot> getMessagesStream(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
