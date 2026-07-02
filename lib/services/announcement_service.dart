import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement.dart';

class AnnouncementService {
  final FirebaseFirestore _db;

  AnnouncementService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _announcements => _db.collection('announcements');

  Stream<List<Announcement>> watchAll() {
    return _announcements
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Announcement.fromFirestore).toList());
  }

  Future<String> create(Announcement announcement) async {
    final ref = await _announcements.add(announcement.toMap());
    return ref.id;
  }

  Future<void> update(String id, Announcement announcement) =>
      _announcements.doc(id).update(announcement.toMap());

  Future<void> delete(String id) => _announcements.doc(id).delete();
}
