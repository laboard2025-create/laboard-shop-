import 'package:flutter/material.dart';

import 'home/home_view.dart';
import 'marketplace/marketplace_view.dart';
import 'profile/member_profile_view.dart';
import 'rooms/rooms_view.dart';

/// 主要 4-tab 導航殼：Home / 組局 / 商店 / 我的。
/// 用 IndexedStack 保留各 tab 嘅畫面狀態（例如 RoomsView 揀選咗邊個房）。
class RootTabScaffold extends StatefulWidget {
  const RootTabScaffold({super.key});

  @override
  State<RootTabScaffold> createState() => _RootTabScaffoldState();
}

class _RootTabScaffoldState extends State<RootTabScaffold> {
  int _index = 0;

  static const _tabs = [
    HomeView(),
    RoomsView(),
    MarketplaceView(),
    MemberProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), activeIcon: Icon(Icons.groups), label: '組局'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: '商店'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
