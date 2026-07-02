import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_item.dart';

enum PaymentMethod {
  cash,
  payme,
  fps;

  static PaymentMethod fromLabel(String label) {
    switch (label) {
      case 'payme':
        return PaymentMethod.payme;
      case 'fps':
        return PaymentMethod.fps;
      default:
        return PaymentMethod.cash;
    }
  }

  String get label => name;

  String get displayLabel => switch (this) {
        PaymentMethod.cash => '現金',
        PaymentMethod.payme => 'PayMe',
        PaymentMethod.fps => 'FPS 轉數快',
      };
}

enum OrderStatus {
  pending,
  paid,
  shipped,
  completed;

  static OrderStatus fromLabel(String label) {
    switch (label) {
      case 'paid':
        return OrderStatus.paid;
      case 'shipped':
        return OrderStatus.shipped;
      case 'completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.pending;
    }
  }

  String get label => name;

  String get displayLabel => switch (this) {
        OrderStatus.pending => '待確認',
        OrderStatus.paid => '已付款',
        OrderStatus.shipped => '已出貨',
        OrderStatus.completed => '已完成',
      };
}

class Order {
  final String id;
  final String customerId; // uid，用於權限規則判斷擁有者
  final String customerName;
  final String? customerEmail;
  final String customerPhone;
  final List<OrderItem> items;
  final num total;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final DateTime? date;

  const Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerEmail,
    required this.customerPhone,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    this.date,
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final rawItems = data['items'] as List<dynamic>? ?? [];
    return Order(
      id: doc.id,
      customerId: data['customerId'] as String? ?? '',
      customerName: data['customerName'] as String? ?? '',
      customerEmail: data['customerEmail'] as String?,
      customerPhone: data['customerPhone'] as String? ?? '',
      items: rawItems
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      total: data['total'] as num? ?? 0,
      paymentMethod: PaymentMethod.fromLabel(data['paymentMethod'] as String? ?? 'cash'),
      status: OrderStatus.fromLabel(data['status'] as String? ?? 'pending'),
      date: (data['date'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'customerId': customerId,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'items': items.map((e) => e.toMap()).toList(),
        'total': total,
        'paymentMethod': paymentMethod.label,
        'status': status.label,
        'date': date != null ? Timestamp.fromDate(date!) : FieldValue.serverTimestamp(),
      };
}
