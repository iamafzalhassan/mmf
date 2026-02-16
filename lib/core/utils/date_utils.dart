class DateTimeUtils {
  static String generateRefNo() {
    final random = (DateTime.now().millisecond % 1000).toString().padLeft(6, '0');
    return 'KJM-$random';
  }
}