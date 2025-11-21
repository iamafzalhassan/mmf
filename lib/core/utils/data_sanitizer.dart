class DataSanitizer {
  static String sanitizeString(String value) {
    if (value.isEmpty) return value;
    String sanitized = value.toUpperCase();
    sanitized = sanitized.trim();
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');
    sanitized = sanitized.replaceAll(RegExp(r'\s+([.,!?;:])'), r'$1');
    sanitized = sanitized.replaceAll(RegExp(r'\(\s+'), '(');
    sanitized = sanitized.replaceAll(RegExp(r'\s+\)'), ')');

    return sanitized;
  }

  static List<String> sanitizeList(List<String> values) {
    return values
        .where((item) => item.trim().isNotEmpty)
        .map((item) => sanitizeString(item))
        .toList();
  }

  static String sanitizeAdmissionNo(String admissionNo) {
    if (admissionNo.isEmpty) return admissionNo;
    String sanitized = admissionNo.toUpperCase().trim();
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');
    sanitized = sanitized.replaceAll(RegExp(r'[^\dA-Z\-/\s]'), '');
    return sanitized;
  }

  static String sanitizeAddress(String address) {
    if (address.isEmpty) return address;
    String sanitized = address.toUpperCase().trim();
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');
    sanitized = sanitized.replaceAll(RegExp(r',+'), ',');
    sanitized = sanitized.replaceAll(RegExp(r'\s+,'), ',');
    sanitized = sanitized.replaceAll(RegExp(r',\s*'), ', ');
    sanitized = sanitized.replaceAll(RegExp(r',\s*$'), '');
    return sanitized;
  }

  static String sanitizeFamiliesCount(String count) {
    if (count.isEmpty) return count;
    return count.trim().replaceAll(RegExp(r'[^\d]'), '');
  }

  static String sanitizePhone(String phone) {
    if (phone.isEmpty) return phone;
    String sanitized = phone.trim();
    sanitized = sanitized.replaceAll(RegExp(r'[^\d]'), '');
    return sanitized;
  }

  static String sanitizeNIC(String nic) {
    if (nic.isEmpty) return nic;
    String sanitized = nic.toUpperCase().trim();
    sanitized = sanitized.replaceAll(RegExp(r'[^\dVX]'), '');
    return sanitized;
  }

  static String sanitizeYear(String year) {
    if (year.isEmpty) return year;
    String sanitized = year.trim().replaceAll(RegExp(r'[^\d]'), '');
    return sanitized;
  }
}