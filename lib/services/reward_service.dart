import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/reward.dart';
import '../models/user_profile.dart';

class NotEnoughPointsException implements Exception {}

class RewardOutOfStockException implements Exception {}

class RewardService {
  final FirebaseFirestore _db;

  RewardService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _rewards => _db.collection('rewards');

  Stream<List<Reward>> watchActive() {
    return _rewards
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map(Reward.fromFirestore).toList());
  }

  Future<String> create(Reward reward) async {
    final ref = await _rewards.add(reward.toMap());
    return ref.id;
  }

  Future<void> update(String id, Reward reward) => _rewards.doc(id).update(reward.toMap());

  Future<void> delete(String id) => _rewards.doc(id).delete();

  /// 兌換獎勵：用 transaction 同時扣分、扣庫存、寫 voucher + history，
  /// 避免用戶連續快速撳兩下造成雙重扣分。
  Future<void> redeem({required String uid, required String rewardId}) async {
    final rewardRef = _rewards.doc(rewardId);
    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final rewardSnap = await tx.get(rewardRef);
      final userSnap = await tx.get(userRef);
      if (!rewardSnap.exists || !userSnap.exists) return;

      final reward = Reward.fromFirestore(rewardSnap);
      final user = UserProfile.fromFirestore(userSnap);

      if (user.points < reward.costPoints) {
        throw NotEnoughPointsException();
      }
      if (reward.stock != null && reward.stock! <= 0) {
        throw RewardOutOfStockException();
      }

      tx.update(userRef, {'points': user.points - reward.costPoints});
      if (reward.stock != null) {
        tx.update(rewardRef, {'stock': reward.stock! - 1});
      }

      final voucherRef = userRef.collection('vouchers').doc();
      tx.set(voucherRef, Voucher(id: '', rewardId: rewardId, title: reward.title).toMap());

      final historyRef = userRef.collection('history').doc();
      tx.set(
        historyRef,
        HistoryEntry(
          id: '',
          type: HistoryType.redemption,
          refId: rewardId,
          amount: reward.costPoints,
        ).toMap(),
      );
    });
  }
}
