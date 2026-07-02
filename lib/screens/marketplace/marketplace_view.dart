import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class MarketplaceView extends StatelessWidget {
  const MarketplaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('二手商店')),
      body: const Center(
        child: Text('商品列表 / 篩選 / 詳情 (即將推出)',
            style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ),
    );
  }
}
