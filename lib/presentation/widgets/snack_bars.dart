import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

extension SnackBars on BuildContext {
  void showErrorSnackBar(String message) => showMessageSnackBar(backgroundColor: AppTheme.red, icon: Icons.info_rounded, message: message);

  void showSuccessSnackBar(String message) => showMessageSnackBar(backgroundColor: AppTheme.green2, icon: Icons.check_circle_rounded, message: message);

  void showMessageSnackBar({required Color backgroundColor, required IconData icon, required String message}) => ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(children: [Icon(icon, color: Colors.white), const SizedBox(width: 12), Text(message, style: const TextStyle(fontSize: 16))]),
      margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(this).height - 100, left: 20, right: 20)));
}
