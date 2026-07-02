import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/board_game_product.dart';

class ProductService {
  final FirebaseFirestore _db;

  ProductService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products => _db.collection('products');

  Stream<List<BoardGameProduct>> watchAll() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(BoardGameProduct.fromFirestore).toList());
  }

  Future<BoardGameProduct?> getById(String id) async {
    final doc = await _products.doc(id).get();
    return doc.exists ? BoardGameProduct.fromFirestore(doc) : null;
  }

  Future<String> create(BoardGameProduct product) async {
    final ref = await _products.add(product.toMap());
    return ref.id;
  }

  Future<void> update(String id, BoardGameProduct product) => _products.doc(id).update(product.toMap());

  Future<void> delete(String id) => _products.doc(id).delete();
}
