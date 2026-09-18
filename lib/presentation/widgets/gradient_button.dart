import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, this.isLoading = false, required this.text, this.icon, required this.onPressed});

  final bool isLoading;

  final String text;

  final IconData? icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(blurRadius: 12, color: AppTheme.green2.withValues(alpha: 0.3), offset: const Offset(0, 4))], color: AppTheme.green2),
      height: 52,
      width: double.infinity,
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isLoading ? null : onPressed,
              child: Center(
                  child: isLoading
                      ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white1)))
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(text, style: const TextStyle(color: AppTheme.white1, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          if (icon != null) ...[const SizedBox(width: 8), Icon(icon, color: AppTheme.white1, size: 20)]
                        ])))));
}
