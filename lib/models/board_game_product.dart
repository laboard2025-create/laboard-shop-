import 'package:cloud_firestore/cloud_firestore.dart';

/// 貨源類別：自家二手（冇寄賣人）或二手寄賣（有寄賣人資訊）。
/// 注意：呢個唔係桌遊類型（見 [category]），係存貨嚟源。
enum SourceType {
  ownStock, // 自家二手
  consignment; // 二手寄賣

  static SourceType fromLabel(String label) =>
      label == '二手寄賣' ? SourceType.consignment : SourceType.ownStock;

  String get label => this == SourceType.consignment ? '二手寄賣' : '自家二手';
}

class BoardGameProduct {
  final String id;
  final String title;
  final String category; // 桌遊類型：策略/派對/合作 等，用作 Marketplace 篩選
  final SourceType sourceType;
  final num price;
  final num? originalPrice;
  final String condition; // S | A | B | C
  final String conditionLabel;
  final String boxSizeGrade; // 體積分級：S | M | L（同 condition 唔同軸）
  final bool isNew; // 物品狀態：true=全新, false=二手
  final int stock;
  final String image;
  final String description;
  final String players;
  final String playTime;
  final String? barcode;
  final String? edition;
  final String? defectNotes;
  final num? minFloorPrice; // 最低底價：staff-only，唔喺顧客畫面顯示
  final String? consignorName;
  final String? consignorPaymentMethod;
  final String? consignorAccount;
  final bool consignorPaid; // 已找數
  final DateTime? intakeDate;
  final DateTime? soldDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BoardGameProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.sourceType,
    required this.price,
    this.originalPrice,
    required this.condition,
    required this.conditionLabel,
    required this.boxSizeGrade,
    required this.isNew,
    required this.stock,
    required this.image,
    required this.description,
    required this.players,
    required this.playTime,
    this.barcode,
    this.edition,
    this.defectNotes,
    this.minFloorPrice,
    this.consignorName,
    this.consignorPaymentMethod,
    this.consignorAccount,
    this.consignorPaid = false,
    this.intakeDate,
    this.soldDate,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardGameProduct.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BoardGameProduct(
      id: doc.id,
      title: data['title'] as String? ?? '',
      category: data['category'] as String? ?? '',
      sourceType: SourceType.fromLabel(data['sourceType'] as String? ?? '自家二手'),
      price: data['price'] as num? ?? 0,
      originalPrice: data['originalPrice'] as num?,
      condition: data['condition'] as String? ?? 'A',
      conditionLabel: data['conditionLabel'] as String? ?? '',
      boxSizeGrade: data['boxSizeGrade'] as String? ?? 'M',
      isNew: data['isNew'] as bool? ?? false,
      stock: data['stock'] as int? ?? 0,
      image: data['image'] as String? ?? '',
      description: data['description'] as String? ?? '',
      players: data['players'] as String? ?? '',
      playTime: data['playTime'] as String? ?? '',
      barcode: data['barcode'] as String?,
      edition: data['edition'] as String?,
      defectNotes: data['defectNotes'] as String?,
      minFloorPrice: data['minFloorPrice'] as num?,
      consignorName: data['consignorName'] as String?,
      consignorPaymentMethod: data['consignorPaymentMethod'] as String?,
      consignorAccount: data['consignorAccount'] as String?,
      consignorPaid: data['consignorPaid'] as bool? ?? false,
      intakeDate: (data['intakeDate'] as Timestamp?)?.toDate(),
      soldDate: (data['soldDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'category': category,
        'sourceType': sourceType.label,
        'price': price,
        'originalPrice': originalPrice,
        'condition': condition,
        'conditionLabel': conditionLabel,
        'boxSizeGrade': boxSizeGrade,
        'isNew': isNew,
        'stock': stock,
        'image': image,
        'description': description,
        'players': players,
        'playTime': playTime,
        'barcode': barcode,
        'edition': edition,
        'defectNotes': defectNotes,
        'minFloorPrice': minFloorPrice,
        'consignorName': consignorName,
        'consignorPaymentMethod': consignorPaymentMethod,
        'consignorAccount': consignorAccount,
        'consignorPaid': consignorPaid,
        'intakeDate': intakeDate != null ? Timestamp.fromDate(intakeDate!) : null,
        'soldDate': soldDate != null ? Timestamp.fromDate(soldDate!) : null,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
