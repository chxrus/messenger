import 'package:messenger/repositories/auth/models/models.dart';
import 'package:messenger/repositories/chat/models/message_model.dart';

abstract interface class IChatService {
  Stream<List<UserModel>> getUsersStream();
  Future<void> sendMessage(String receiverID, String message);
  Stream<List<MessageModel>> getMessagesStream(
      String userID, String otherUserID);
}
