import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RoomsView extends StatelessWidget {
  const RoomsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('組局報名')),
      body: const Center(
        child: Text('組局列表 / 詳情 / 聊天室 (即將推出)',
            style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
      ),
    );
  }
}
