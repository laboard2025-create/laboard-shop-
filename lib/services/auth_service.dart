import 'package:firebase_auth/firebase_auth.dart';

/// 包住 Firebase Phone Auth 嘅登入流程：
/// 1. sendOtp() 送出驗證碼
/// 2. verifyOtp() 用驗證碼登入
class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// 送出 OTP 到 [phoneNumber]（必須包含國家區號，例如 +852xxxxxxxx）。
  /// [codeSent] 喺驗證碼發送成功後被叫，帶住 verificationId 俾下一步用。
  /// [onError] 喺驗證失敗（例如格式錯誤/超過頻率限制）時被叫。
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
    required void Function(FirebaseAuthException e) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: onError,
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();
}
