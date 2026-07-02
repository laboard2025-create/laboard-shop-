import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboard 二手桌遊舖')),
      body: const Center(
        child: Text('首頁 — 公告 / 商品推介 / 組局預覽 (即將推出)',
            style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ),
    );
  }
}
