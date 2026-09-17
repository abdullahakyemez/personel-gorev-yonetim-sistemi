import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/auth/domain/services/password_hasher.dart';

void main() {
  group('PasswordHasher Tests', () {
    test('standard sha256 vectors are accurate', () {
      expect(
        PasswordHasher.sha256(''),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      expect(
        PasswordHasher.sha256('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('generateSalt produces non-empty hex strings', () {
      final salt1 = PasswordHasher.generateSalt();
      final salt2 = PasswordHasher.generateSalt();

      expect(salt1, isNotEmpty);
      expect(salt2, isNotEmpty);
      expect(salt1, isNot(equals(salt2)));
    });

    test('hashPassword and verifyPassword work correctly', () {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('admin123', salt);

      expect(PasswordHasher.verifyPassword('admin123', salt, hash), isTrue);
      expect(PasswordHasher.verifyPassword('wrongpass', salt, hash), isFalse);
    });
  });
}
