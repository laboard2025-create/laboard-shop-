import '../models/board_game_product.dart';

/// 售出狀態 (自動) — 唔存喺 Firestore，永遠由 stock 現算，避免同實際庫存脫節。
enum SoldStatus { available, soldOut }

SoldStatus soldStatusOf(BoardGameProduct product) =>
    product.stock <= 0 ? SoldStatus.soldOut : SoldStatus.available;

extension SoldStatusLabel on SoldStatus {
  String get label => switch (this) {
        SoldStatus.available => '🟢 在售',
        SoldStatus.soldOut => '🔴 已售出',
      };
}

/// 提醒及警告 (自動) — 上架超過 [staleDays] 日仲未賣出，就提示留意。
const int staleDaysThreshold = 90;

String? inventoryAlertOf(BoardGameProduct product, {DateTime? now}) {
  if (product.stock <= 0) return null;
  final intake = product.intakeDate;
  if (intake == null) return null;
  final days = (now ?? DateTime.now()).difference(intake).inDays;
  if (days > staleDaysThreshold) {
    return '⚠️ 已上架 $days 日未售出';
  }
  return null;
}
