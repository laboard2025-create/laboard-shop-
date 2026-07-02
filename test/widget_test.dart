import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vipapp/screens/auth/phone_login_screen.dart';

void main() {
  testWidgets('PhoneLoginScreen shows shop name and phone field', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PhoneLoginScreen()),
    );

    expect(find.text('Laboard 二手桌遊舖'), findsOneWidget);
    expect(find.text('取得驗證碼'), findsOneWidget);
  });
}
