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

    test('generateSalt produces non-empty hex strings with expected lengths', () {
      final salt1 = PasswordHasher.generateSalt();
      final salt2 = PasswordHasher.generateSalt();
      final saltLong = PasswordHasher.generateSalt(24);

      expect(salt1, isNotEmpty);
      expect(salt2, isNotEmpty);
      expect(salt1, isNot(equals(salt2)));
      // Default 16 bytes = 32 hex characters
      expect(salt1.length, 32);
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(salt1), isTrue);
      // 24 bytes = 48 hex characters
      expect(saltLong.length, 48);
    });

    test('hashPassword produces pbkdf2 format with 100.000 iterations', () {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPassword('admin123', salt);

      expect(hash.startsWith('pbkdf2\$100000\$'), isTrue);

      final parts = hash.split(r'$');
      expect(parts.length, 4);
      expect(parts[0], 'pbkdf2');
      expect(parts[1], '100000');
      expect(parts[2], salt);
      // SHA-256 derived key length: 32 bytes = 64 hex characters
      expect(parts[3].length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(parts[3]), isTrue);
    });

    test('new format hash and verify work correctly with valid password', () {
      final salt = PasswordHasher.generateSalt();
      const password = 'SuperSecretPassword#2026';
      final hash = PasswordHasher.hashPassword(password, salt);

      expect(PasswordHasher.verifyPassword(password, salt, hash), isTrue);
    });

    test('new format verify rejects incorrect password', () {
      final salt = PasswordHasher.generateSalt();
      const password = 'CorrectPassword';
      final hash = PasswordHasher.hashPassword(password, salt);

      expect(PasswordHasher.verifyPassword('WrongPassword', salt, hash), isFalse);
      expect(PasswordHasher.verifyPassword('', salt, hash), isFalse);
      expect(PasswordHasher.verifyPassword('correctpassword', salt, hash), isFalse);
    });

    test('backward compatibility: legacy single-round sha256 hash is verified correctly', () {
      final salt = PasswordHasher.generateSalt();
      const legacyPassword = 'OldLegacyPassword123';
      // Legacy format: sha256('$salt::$password::$salt')
      final legacyHash = PasswordHasher.sha256('$salt::$legacyPassword::$salt');

      // Verify that this is identified as a legacy hash
      expect(PasswordHasher.isLegacyHash(legacyHash), isTrue);
      expect(PasswordHasher.needsRehash(legacyHash), isTrue);

      // Verify successful verification with correct password
      expect(
        PasswordHasher.verifyPassword(legacyPassword, salt, legacyHash),
        isTrue,
      );

      // Verify rejection of wrong password with legacy hash
      expect(
        PasswordHasher.verifyPassword('WrongPass', salt, legacyHash),
        isFalse,
      );
    });

    test('isLegacyHash and needsRehash identify formats correctly', () {
      final salt = PasswordHasher.generateSalt();
      final newHash = PasswordHasher.hashPassword('pass', salt);
      final legacyHash = PasswordHasher.sha256('$salt::pass::$salt');
      final lowIterationHash = 'pbkdf2\$1000\$$salt\$abcdef0123456789';

      expect(PasswordHasher.isLegacyHash(legacyHash), isTrue);
      expect(PasswordHasher.isLegacyHash(newHash), isFalse);

      expect(PasswordHasher.needsRehash(legacyHash), isTrue);
      expect(PasswordHasher.needsRehash(newHash), isFalse);
      expect(PasswordHasher.needsRehash(lowIterationHash), isTrue);
    });

    test('constantTimeCompare and constantTimeEqualsBytes work as expected', () {
      expect(PasswordHasher.constantTimeCompare('secret_hash', 'secret_hash'), isTrue);
      expect(PasswordHasher.constantTimeCompare('secret_hash', 'other_hash!'), isFalse);
      expect(PasswordHasher.constantTimeCompare('short', 'longer_string'), isFalse);
      expect(PasswordHasher.constantTimeCompare('', ''), isTrue);

      expect(PasswordHasher.constantTimeEqualsBytes([1, 2, 3], [1, 2, 3]), isTrue);
      expect(PasswordHasher.constantTimeEqualsBytes([1, 2, 3], [1, 2, 4]), isFalse);
      expect(PasswordHasher.constantTimeEqualsBytes([1, 2], [1, 2, 3]), isFalse);
    });

    test('verifyPassword safely handles malformed or invalid hash formats', () {
      final salt = PasswordHasher.generateSalt();

      expect(PasswordHasher.verifyPassword('pass', salt, ''), isFalse);
      expect(PasswordHasher.verifyPassword('pass', salt, 'pbkdf2\$invalid'), isFalse);
      expect(PasswordHasher.verifyPassword('pass', salt, 'pbkdf2\$0\$salt\$hash'), isFalse);
      expect(PasswordHasher.verifyPassword('pass', salt, 'pbkdf2\$-500\$salt\$hash'), isFalse);
      expect(PasswordHasher.verifyPassword('pass', salt, 'otheralg\$100000\$salt\$hash'), isFalse);
    });
  });
}
