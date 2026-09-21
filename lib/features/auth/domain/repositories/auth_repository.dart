import '../models/app_user.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AccountLockedException extends AuthException {
  final int remainingSeconds;

  AccountLockedException(this.remainingSeconds)
      : super('Çok fazla başarısız deneme, $remainingSeconds saniye sonra tekrar deneyin.');
}

abstract class AuthRepository {
  /// Kayıtlı kullanıcı oturumunu getirir, yoksa veya geçersizse null döner.
  Future<AppUser?> getSavedSession();

  /// Kullanıcı adı ve şifre ile giriş yapar.
  /// Hatalı kimlik bilgisi veya pasif hesap durumunda [AuthException] fırlatır.
  Future<AppUser> login(String username, String password);

  /// Aktif kullanıcı oturumunu sonlandırır.
  Future<void> logout();

  /// Verilen kimliğe sahip kullanıcıyı getirir.
  Future<AppUser?> getUserById(int id);

  /// Kullanıcının şifresini günceller ve ilk şifre zorunluluğunu kaldırır.
  Future<void> changePassword(int userId, String oldPassword, String newPassword);
}
