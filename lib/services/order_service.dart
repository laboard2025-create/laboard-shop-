import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _db;

  OrderService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orders => _db.collection('orders');

  Stream<List<Order>> watchAll() {
    return _orders
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Order.fromFirestore).toList());
  }

  Stream<List<Order>> watchForCustomer(String uid) {
    return _orders
        .where('customerId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Order.fromFirestore).toList());
  }

  Future<String> create(Order order) async {
    final ref = await _orders.add(order.toMap());
    return ref.id;
  }

  Future<void> updateStatus(String id, OrderStatus status) =>
      _orders.doc(id).update({'status': status.label});
}
