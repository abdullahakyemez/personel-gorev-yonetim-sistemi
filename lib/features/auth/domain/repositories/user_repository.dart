import '../models/app_user.dart';
import '../models/user_role.dart';

abstract class UserRepository {
  /// Sistemdeki tüm kullanıcıları listeler.
  Future<List<AppUser>> getUsers();

  /// Personel sicil numarası bazlı yeni bir kullanıcı oluşturur.
  /// İlk şifre standart olarak Pr123456 belirlenir ve requiresPasswordChange: true yapılır.
  Future<AppUser> createUser({
    int? personnelId,
    required String registryNumber,
    required String fullName,
    required UserRole role,
    String? groupName,
  });

  /// Kullanıcının rol, grup ve aktiflik bilgilerini günceller.
  Future<void> updateUser(
    int id, {
    required UserRole role,
    String? groupName,
    required bool isActive,
  });

  /// Kullanıcının şifresini standart ilk şifreye (Pr123456) sıfırlar ve
  /// ilk girişte yeni şifre belirlemesini zorunlu kılar.
  Future<void> resetPasswordToDefault(int userId);

  /// Kullanıcı kaydını siler. Aktif yöneticinin kendini silmesi engellenir.
  Future<void> deleteUser(int id, int currentAdminId);
}
