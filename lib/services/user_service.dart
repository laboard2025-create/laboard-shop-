import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _db;

  UserService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');

  Stream<UserProfile?> watchProfile(String uid) {
    return _users.doc(uid).snapshots().map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists ? UserProfile.fromFirestore(doc) : null;
  }

  /// 第一次登入時建立會員檔案。
  Future<void> createProfile({
    required String uid,
    required String nickname,
    required String phoneNumber,
  }) async {
    await _users.doc(uid).set({
      'username': uid,
      'nickname': nickname,
      'email': null,
      'phoneNumber': phoneNumber,
      'avatar': '',
      'escapeRate': 0,
      'isStaff': false,
      'joinedRoomsCount': 0,
      'ratingsCount': 0,
      'points': 0,
      'exp': 0,
      'stamps': 0,
      'memberId': 'M${uid.substring(0, 6).toUpperCase()}',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Voucher>> watchVouchers(String uid) {
    return _users
        .doc(uid)
        .collection('vouchers')
        .orderBy('redeemedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Voucher.fromFirestore).toList());
  }

  Stream<List<HistoryEntry>> watchHistory(String uid, {int limit = 20}) {
    return _users
        .doc(uid)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(HistoryEntry.fromFirestore).toList());
  }

  Stream<List<UserProfile>> watchAllMembers() {
    return _users
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(UserProfile.fromFirestore).toList());
  }

  Future<void> setStaff(String uid, bool isStaff) => _users.doc(uid).update({'isStaff': isStaff});
}
