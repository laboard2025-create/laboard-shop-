import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _db;

  ChatService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _chats(String roomId) =>
      _db.collection('rooms').doc(roomId).collection('chats');

  Stream<List<ChatMessage>> watchMessages(String roomId) {
    return _chats(roomId)
        .orderBy('sentAt')
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessage.fromFirestore).toList());
  }

  /// 寄訊息前，security rules 會 check 你係咪 rooms/{roomId}/participants 入面嘅人。
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String text,
  }) {
    return _chats(roomId).add(
      ChatMessage(id: '', senderId: senderId, senderName: senderName, text: text).toMap(),
    );
  }
}
