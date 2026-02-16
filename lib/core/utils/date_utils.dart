import 'dart:math';

class DateTimeUtils {
  static String generateRefNo() {
    String random = (100000 + Random().nextInt(900000)).toString();
    return 'KJM-$random';
  }
}