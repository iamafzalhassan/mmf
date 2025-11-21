class DateTimeUtils {
  static String generateRefNo() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');
    final random = (DateTime.now().millisecond % 1000).toString().padLeft(3, '0');
    return 'KJM-$year$month$day-$hours$minutes$seconds-$random';
  }
}