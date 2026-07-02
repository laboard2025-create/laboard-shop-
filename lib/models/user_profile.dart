import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final String nickname;
  final String? email;
  final String phoneNumber;
  final String avatar;
  final num escapeRate; // 逃跑率 %，愈低愈好
  final bool isStaff;
  final int joinedRoomsCount;
  final int ratingsCount;
  final int points;
  final int exp; // 驅動 VIP 等級，見 utils/vip_tier.dart
  final int stamps; // 印花
  final String memberId;
  final DateTime? createdAt;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.nickname,
    this.email,
    required this.phoneNumber,
    required this.avatar,
    this.escapeRate = 0,
    this.isStaff = false,
    this.joinedRoomsCount = 0,
    this.ratingsCount = 0,
    this.points = 0,
    this.exp = 0,
    this.stamps = 0,
    required this.memberId,
    this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserProfile(
      uid: doc.id,
      username: data['username'] as String? ?? '',
      nickname: data['nickname'] as String? ?? '',
      email: data['email'] as String?,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      avatar: data['avatar'] as String? ?? '',
      escapeRate: data['escapeRate'] as num? ?? 0,
      isStaff: data['isStaff'] as bool? ?? false,
      joinedRoomsCount: data['joinedRoomsCount'] as int? ?? 0,
      ratingsCount: data['ratingsCount'] as int? ?? 0,
      points: data['points'] as int? ?? 0,
      exp: data['exp'] as int? ?? 0,
      stamps: data['stamps'] as int? ?? 0,
      memberId: data['memberId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'username': username,
        'nickname': nickname,
        'email': email,
        'phoneNumber': phoneNumber,
        'avatar': avatar,
        'escapeRate': escapeRate,
        'isStaff': isStaff,
        'joinedRoomsCount': joinedRoomsCount,
        'ratingsCount': ratingsCount,
        'points': points,
        'exp': exp,
        'stamps': stamps,
        'memberId': memberId,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };
}

class Voucher {
  final String id;
  final String rewardId;
  final String title;
  final DateTime? redeemedAt;
  final bool used;

  const Voucher({
    required this.id,
    required this.rewardId,
    required this.title,
    this.redeemedAt,
    this.used = false,
  });

  factory Voucher.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Voucher(
      id: doc.id,
      rewardId: data['rewardId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      redeemedAt: (data['redeemedAt'] as Timestamp?)?.toDate(),
      used: data['used'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'rewardId': rewardId,
        'title': title,
        'redeemedAt': FieldValue.serverTimestamp(),
        'used': used,
      };
}

enum HistoryType {
  purchase,
  redemption;

  static HistoryType fromLabel(String label) =>
      label == 'redemption' ? HistoryType.redemption : HistoryType.purchase;

  String get label => name;
}

class HistoryEntry {
  final String id;
  final HistoryType type;
  final String? refId; // orderId 或 rewardId
  final num amount;
  final DateTime? createdAt;

  const HistoryEntry({
    required this.id,
    required this.type,
    this.refId,
    required this.amount,
    this.createdAt,
  });

  factory HistoryEntry.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HistoryEntry(
      id: doc.id,
      type: HistoryType.fromLabel(data['type'] as String? ?? 'purchase'),
      refId: data['refId'] as String?,
      amount: data['amount'] as num? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.label,
        'refId': refId,
        'amount': amount,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
