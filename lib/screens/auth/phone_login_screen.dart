import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import 'otp_verify_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final digits = _phoneController.text.trim();
    if (digits.length < 8) {
      setState(() => _error = '請輸入正確嘅電話號碼');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });

    final phoneNumber = '+852$digits';
    final authService = context.read<AuthService>();

    await authService.sendOtp(
      phoneNumber: phoneNumber,
      codeSent: (verificationId) {
        if (!mounted) return;
        setState(() => _sending = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpVerifyScreen(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      onError: (FirebaseAuthException e) {
        if (!mounted) return;
        setState(() {
          _sending = false;
          _error = e.message ?? '發送驗證碼失敗，請重試';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.casino, size: 64, color: AppColors.gold),
                  const SizedBox(height: 16),
                  Text(
                    'Laboard 二手桌遊舖',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '請輸入電話號碼登入',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      prefixText: '+852  ',
                      labelText: '電話號碼',
                      hintText: '9xxxxxxx',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: AppColors.error)),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _sending ? null : _sendOtp,
                    child: _sending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('取得驗證碼'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
