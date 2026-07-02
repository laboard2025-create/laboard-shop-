import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/meetup_room.dart';
import '../models/room_participant.dart';

class RoomAlreadyFullException implements Exception {}

class RoomService {
  final FirebaseFirestore _db;

  RoomService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _rooms => _db.collection('rooms');

  Stream<List<MeetupRoom>> watchAll() {
    return _rooms
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map(MeetupRoom.fromFirestore).toList());
  }

  Stream<MeetupRoom?> watchOne(String roomId) {
    return _rooms.doc(roomId).snapshots().map((doc) => doc.exists ? MeetupRoom.fromFirestore(doc) : null);
  }

  Stream<List<RoomParticipant>> watchParticipants(String roomId) {
    return _rooms
        .doc(roomId)
        .collection('participants')
        .orderBy('joinedAt')
        .snapshots()
        .map((snap) => snap.docs.map(RoomParticipant.fromFirestore).toList());
  }

  Future<bool> isParticipant(String roomId, String uid) async {
    final doc = await _rooms.doc(roomId).collection('participants').doc(uid).get();
    return doc.exists;
  }

  Future<String> createRoom(MeetupRoom room) async {
    final ref = await _rooms.add(room.toMap());
    return ref.id;
  }

  /// 加入組局：喺同一個 transaction 入面check人數上限、寫入 participant、
  /// 同時更新 room 嘅 currentPlayerCount / status，避免人數超額嘅 race condition。
  Future<void> joinRoom({
    required String roomId,
    required String uid,
    required String nickname,
  }) async {
    final roomRef = _rooms.doc(roomId);
    final participantRef = roomRef.collection('participants').doc(uid);

    await _db.runTransaction((tx) async {
      final roomSnap = await tx.get(roomRef);
      if (!roomSnap.exists) return;
      final room = MeetupRoom.fromFirestore(roomSnap);

      final participantSnap = await tx.get(participantRef);
      if (participantSnap.exists) return; // 已經加入咗，唔使再計一次

      if (room.currentPlayerCount >= room.maxPlayers) {
        throw RoomAlreadyFullException();
      }

      final newCount = room.currentPlayerCount + 1;
      tx.set(participantRef, RoomParticipant(uid: uid, nickname: nickname).toMap());
      tx.update(roomRef, {
        'currentPlayerCount': newCount,
        'status': newCount >= room.maxPlayers ? RoomStatus.full.label : RoomStatus.recruiting.label,
      });
    });
  }

  /// 退出組局：減返人數，如果原本已滿就打返做 recruiting（除非已經 started）。
  Future<void> leaveRoom({
    required String roomId,
    required String uid,
  }) async {
    final roomRef = _rooms.doc(roomId);
    final participantRef = roomRef.collection('participants').doc(uid);

    await _db.runTransaction((tx) async {
      final roomSnap = await tx.get(roomRef);
      if (!roomSnap.exists) return;
      final room = MeetupRoom.fromFirestore(roomSnap);

      final participantSnap = await tx.get(participantRef);
      if (!participantSnap.exists) return;

      final newCount = (room.currentPlayerCount - 1).clamp(0, room.maxPlayers);
      tx.delete(participantRef);
      tx.update(roomRef, {
        'currentPlayerCount': newCount,
        'status': room.status == RoomStatus.started ? RoomStatus.started.label : RoomStatus.recruiting.label,
      });
    });
  }
}
