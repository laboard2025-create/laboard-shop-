import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../root_tab_scaffold.dart';
import 'create_profile_screen.dart';
import 'phone_login_screen.dart';

/// App 入口把關：未登入 -> 電話登入；已登入但未有會員檔案 -> 建立檔案；
/// 兩者都完成 -> 主頁 4-tab 畫面。
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashLoading();
        }
        final user = snapshot.data;
        if (user == null) {
          return const PhoneLoginScreen();
        }
        return _ProfileGate(uid: user.uid, phoneNumber: user.phoneNumber ?? '');
      },
    );
  }
}

class _ProfileGate extends StatelessWidget {
  final String uid;
  final String phoneNumber;

  const _ProfileGate({required this.uid, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final userService = context.read<UserService>();
    return StreamBuilder<UserProfile?>(
      stream: userService.watchProfile(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashLoading();
        }
        final profile = snapshot.data;
        if (profile == null) {
          return CreateProfileScreen(uid: uid, phoneNumber: phoneNumber);
        }
        return const RootTabScaffold();
      },
    );
  }
}

class _SplashLoading extends StatelessWidget {
  const _SplashLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );
  }
}
