import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'SFProDisplay',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}