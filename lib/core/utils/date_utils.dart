class DateTimeUtils {
  static String generateRefNo() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final random = (DateTime.now().millisecond % 1000).toString().padLeft(3, '0');
    return 'KJM-$year$month$day-$random';
  }
}