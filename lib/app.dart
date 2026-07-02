import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth/auth_gate.dart';
import 'services/announcement_service.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/order_service.dart';
import 'services/product_service.dart';
import 'services/reward_service.dart';
import 'services/room_service.dart';
import 'services/user_service.dart';
import 'theme/app_theme.dart';

class LaboardApp extends StatelessWidget {
  const LaboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => RoomService()),
        Provider(create: (_) => ChatService()),
        Provider(create: (_) => AnnouncementService()),
        Provider(create: (_) => OrderService()),
        Provider(create: (_) => RewardService()),
      ],
      child: MaterialApp(
        title: 'Laboard 二手桌遊舖',
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const AuthGate(),
      ),
    );
  }
}
