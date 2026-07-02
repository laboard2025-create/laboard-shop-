enum VipTier { bronze, silver, gold, platinum, diamond }

/// 佔位門檻值，日後可以自由調整。
VipTier vipTierForExp(int exp) {
  if (exp >= 10000) return VipTier.diamond;
  if (exp >= 5000) return VipTier.platinum;
  if (exp >= 2000) return VipTier.gold;
  if (exp >= 500) return VipTier.silver;
  return VipTier.bronze;
}

extension VipTierLabel on VipTier {
  String get label => switch (this) {
        VipTier.bronze => '青銅',
        VipTier.silver => '白銀',
        VipTier.gold => '黃金',
        VipTier.platinum => '白金',
        VipTier.diamond => '鑽石',
      };
}
