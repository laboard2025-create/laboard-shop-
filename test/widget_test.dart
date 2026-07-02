import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vipapp/main.dart';

void main() {
  testWidgets('HomePage shows title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const HomePage(),
      ),
    );

    expect(find.text('Laboard 二手桌遊舖'), findsOneWidget);
  });
}
