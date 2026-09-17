import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp =
      RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  /// Zorunlu alan kontrolü
  static String? requiredField(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName alanı zorunludur.'
          : 'Bu alan zorunludur.';
    }
    return null;
  }

  /// E-posta format doğrulaması
  static String? email(String? value, {bool required = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return required ? 'E-posta adresi zorunludur.' : null;
    }
    if (!_emailRegExp.hasMatch(text)) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

  /// Telefon numarası format doğrulaması (10-11 basamak ve +90 ülke kodu desteği)
  static String? phone(String? value, {bool required = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return required ? 'Telefon numarası zorunludur.' : null;
    }
    var digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('90') && digits.length >= 12) {
      digits = digits.substring(2);
    }
    if (digits.startsWith('0') && digits.length == 11) {
      digits = digits.substring(1);
    }
    if (digits.length != 10) {
      return 'Geçerli bir telefon numarası giriniz (örn: 05XX XXX XX XX).';
    }
    return null;
  }

  /// Sicil numarası benzersizlik ve zorunluluk kontrolü
  static String? registryNumber(
    String? value, {
    required List<Personnel> existingPersonnel,
    int? currentPersonnelId,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Sicil numarası zorunludur.';
    }
    final isDuplicate = existingPersonnel.any((person) =>
        person.id != currentPersonnelId &&
        person.registryNumber.trim() == text);

    if (isDuplicate) {
      return 'Bu sicil numarası ($text) başka bir personele aittir.';
    }
    return null;
  }

  /// İki tarih arasındaki sıralama doğrulaması
  static String? dateOrder(
    DateTime? start,
    DateTime? end, [
    String? message,
  ]) {
    if (start != null && end != null) {
      final startDateOnly = DateTime(start.year, start.month, start.day);
      final endDateOnly = DateTime(end.year, end.month, end.day);
      if (endDateOnly.isBefore(startDateOnly)) {
        return message ?? 'Bitiş tarihi, başlangıç tarihinden önce olamaz.';
      }
    }
    return null;
  }
}
