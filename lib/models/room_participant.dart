import 'package:cloud_firestore/cloud_firestore.dart';

class RoomParticipant {
  final String uid;
  final String nickname;
  final DateTime? joinedAt;

  const RoomParticipant({
    required this.uid,
    required this.nickname,
    this.joinedAt,
  });

  factory RoomParticipant.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RoomParticipant(
      uid: doc.id,
      nickname: data['nickname'] as String? ?? '',
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'nickname': nickname,
        'joinedAt': FieldValue.serverTimestamp(),
      };
}
