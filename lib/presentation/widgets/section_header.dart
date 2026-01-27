import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;

  const SectionHeader({
    super.key,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.green2.withOpacity(0.15),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: AppTheme.green2,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.black,
            fontFamily: 'SFProDisplay',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}