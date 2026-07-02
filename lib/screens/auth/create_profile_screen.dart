import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/user_service.dart';
import '../../theme/app_colors.dart';

/// 第一次登入時要求輸入暱稱，先建立 users/{uid} 會員檔案。
class CreateProfileScreen extends StatefulWidget {
  final String uid;
  final String phoneNumber;

  const CreateProfileScreen({super.key, required this.uid, required this.phoneNumber});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nicknameController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = '請輸入暱稱');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await context.read<UserService>().createProfile(
            uid: widget.uid,
            nickname: nickname,
            phoneNumber: widget.phoneNumber,
          );
      // 建立成功後，AuthGate 監聽緊 users/{uid} 嘅 stream 會自動轉去主頁，唔使手動導航。
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = '建立會員檔案失敗，請重試';
      });
    }
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
                  const Icon(Icons.person_add_alt, size: 56, color: AppColors.gold),
                  const SizedBox(height: 16),
                  Text('歡迎加入！', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  const Text(
                    '請輸入你嘅暱稱，完成會員登記',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nicknameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: '暱稱'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: AppColors.error)),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('完成登記'),
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
