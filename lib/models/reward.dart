import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String id;
  final String title;
  final String description;
  final int costPoints;
  final int? stock; // null = 無限
  final bool active;
  final DateTime? createdAt;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.costPoints,
    this.stock,
    this.active = true,
    this.createdAt,
  });

  factory Reward.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Reward(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      costPoints: data['costPoints'] as int? ?? 0,
      stock: data['stock'] as int?,
      active: data['active'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'costPoints': costPoints,
        'stock': stock,
        'active': active,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };
}
