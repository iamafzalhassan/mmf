import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.icon});

  final String title;

  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.green2.withValues(alpha: 0.15)), padding: const EdgeInsets.all(8), child: Icon(icon, color: AppTheme.green2, size: 22)),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(color: AppTheme.black, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2))
      ]);
}
