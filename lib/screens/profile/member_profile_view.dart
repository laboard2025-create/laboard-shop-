import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/vip_tier.dart';

class MemberProfileView extends StatelessWidget {
  const MemberProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthService>().currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的會員'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '登出',
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: StreamBuilder<UserProfile?>(
        stream: context.read<UserService>().watchProfile(uid),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }
          final tier = vipTierForExp(profile.exp);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.nickname, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('會員編號：${profile.memberId}',
                          style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      Chip(
                        label: Text('${tier.label} 會員'),
                        backgroundColor: AppColors.goldMuted.withValues(alpha: 0.25),
                        labelStyle: const TextStyle(color: AppColors.gold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatColumn(label: '積分', value: '${profile.points}'),
                          _StatColumn(label: '經驗值', value: '${profile.exp}'),
                          _StatColumn(label: '印花', value: '${profile.stamps}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (profile.isStaff) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('老闆後台'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('老闆後台即將推出')),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
