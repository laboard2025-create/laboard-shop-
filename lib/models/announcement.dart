import 'package:cloud_firestore/cloud_firestore.dart';

enum AnnouncementTag {
  activity, // 活動
  secondhand, // 二手
  system, // 系統
  important; // 重要

  static AnnouncementTag fromLabel(String label) {
    switch (label) {
      case '二手':
        return AnnouncementTag.secondhand;
      case '系統':
        return AnnouncementTag.system;
      case '重要':
        return AnnouncementTag.important;
      default:
        return AnnouncementTag.activity;
    }
  }

  String get label => switch (this) {
        AnnouncementTag.activity => '活動',
        AnnouncementTag.secondhand => '二手',
        AnnouncementTag.system => '系統',
        AnnouncementTag.important => '重要',
      };
}

class Announcement {
  final String id;
  final String title;
  final String content;
  final AnnouncementTag tag;
  final bool isNew;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    this.isNew = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Announcement.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Announcement(
      id: doc.id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      tag: AnnouncementTag.fromLabel(data['tag'] as String? ?? '活動'),
      isNew: data['isNew'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'tag': tag.label,
        'isNew': isNew,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
