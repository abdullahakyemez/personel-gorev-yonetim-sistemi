import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;

/// Provides cryptographic password hashing and verification using
/// PBKDF2-HMAC-SHA256 with backward compatibility for legacy SHA-256 hashes.
class PasswordHasher {
  const PasswordHasher._();

  static const String algorithm = 'pbkdf2';
  static const int defaultIterations = 100000;
  static const int derivedKeyLength = 32;

  /// Generates a cryptographically secure random hexadecimal salt.
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Hashes [password] with [salt] using PBKDF2-HMAC-SHA256.
  ///
  /// Returns a formatted string: `pbkdf2$<iterations>$<salt>$<hashHex>`.
  static String hashPassword(
    String password,
    String salt, [
    int iterations = defaultIterations,
  ]) {
    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(salt);
    final derivedKey = _pbkdf2HmacSha256(
      passwordBytes: passwordBytes,
      saltBytes: saltBytes,
      iterations: iterations,
      keyLength: derivedKeyLength,
    );
    final hashHex = _bytesToHex(derivedKey);
    return '$algorithm\$$iterations\$$salt\$$hashHex';
  }

  /// Verifies [password] against [expectedHash] in constant time.
  ///
  /// Supports both new PBKDF2 hashes (`pbkdf2$<iter>$<salt>$<hash>`)
  /// and legacy SHA-256 hashes (`sha256('$salt::$password::$salt')`).
  static bool verifyPassword(
    String password,
    String salt,
    String expectedHash,
  ) {
    if (isLegacyHash(expectedHash)) {
      final legacyCalculated = sha256('$salt::$password::$salt');
      return constantTimeCompare(legacyCalculated, expectedHash);
    }

    final parts = expectedHash.split(r'$');
    if (parts.length != 4 || parts[0] != algorithm) {
      return false;
    }

    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) {
      return false;
    }

    final storedSalt = parts[2].isNotEmpty ? parts[2] : salt;
    final expectedKeyHex = parts[3];

    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(storedSalt);
    final derivedKey = _pbkdf2HmacSha256(
      passwordBytes: passwordBytes,
      saltBytes: saltBytes,
      iterations: iterations,
      keyLength: derivedKeyLength,
    );
    final calculatedKeyHex = _bytesToHex(derivedKey);

    return constantTimeCompare(calculatedKeyHex, expectedKeyHex);
  }

  /// Returns true if [hash] was created with the legacy SHA-256 algorithm.
  static bool isLegacyHash(String hash) {
    return !hash.startsWith('$algorithm\$');
  }

  /// Returns true if [hash] requires re-hashing (legacy format or lower iteration count).
  static bool needsRehash(String hash) {
    if (isLegacyHash(hash)) {
      return true;
    }
    final parts = hash.split(r'$');
    if (parts.length >= 2) {
      final iter = int.tryParse(parts[1]);
      if (iter != null && iter < defaultIterations) {
        return true;
      }
    }
    return false;
  }

  /// Constant-time comparison between two strings to prevent timing attacks.
  static bool constantTimeCompare(String a, String b) {
    final aBytes = utf8.encode(a);
    final bBytes = utf8.encode(b);
    return constantTimeEqualsBytes(aBytes, bBytes);
  }

  /// Constant-time comparison between two byte lists.
  static bool constantTimeEqualsBytes(List<int> a, List<int> b) {
    var result = a.length ^ b.length;
    final minLength = a.length < b.length ? a.length : b.length;
    for (var i = 0; i < minLength; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Computes standard SHA-256 hex digest using package:crypto.
  static String sha256(String input) {
    return crypto.sha256.convert(utf8.encode(input)).toString();
  }

  /// PBKDF2 key derivation using HMAC-SHA256.
  static Uint8List _pbkdf2HmacSha256({
    required List<int> passwordBytes,
    required List<int> saltBytes,
    required int iterations,
    int keyLength = 32,
  }) {
    final hmac = crypto.Hmac(crypto.sha256, passwordBytes);
    final numBlocks = (keyLength + 31) ~/ 32;
    final derivedKey = Uint8List(keyLength);

    for (var block = 1; block <= numBlocks; block++) {
      final saltPlusBlock = Uint8List(saltBytes.length + 4);
      saltPlusBlock.setRange(0, saltBytes.length, saltBytes);
      final byteData = ByteData.sublistView(saltPlusBlock, saltBytes.length);
      byteData.setUint32(0, block, Endian.big);

      var u = hmac.convert(saltPlusBlock).bytes;
      final xorSum = Uint8List.fromList(u);

      for (var iter = 1; iter < iterations; iter++) {
        u = hmac.convert(u).bytes;
        for (var i = 0; i < 32; i++) {
          xorSum[i] ^= u[i];
        }
      }

      final destOffset = (block - 1) * 32;
      final copyLength = min(32, keyLength - destOffset);
      derivedKey.setRange(destOffset, destOffset + copyLength, xorSum);
    }

    return derivedKey;
  }

  static String _bytesToHex(List<int> bytes) {
    final buffer = StringBuffer();
    for (final b in bytes) {
      buffer.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
