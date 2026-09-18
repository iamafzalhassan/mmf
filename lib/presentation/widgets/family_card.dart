import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/domain/entities/family_member.dart';

class FamilyMemberCard extends StatelessWidget {
  const FamilyMemberCard({super.key, required this.member, required this.onRemove, required this.onTap});

  final FamilyMember member;

  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isHead = member.relationship == 'Head of Family';

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: isHead ? AppTheme.green2 : AppTheme.gray3, width: isHead ? 2 : 1),
            borderRadius: BorderRadius.circular(12),
            color: isHead ? AppTheme.green2.withValues(alpha: 0.05) : AppTheme.white5.withValues(alpha: 0.3)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: isHead ? AppTheme.green2.withValues(alpha: 0.15) : AppTheme.gray1),
                          height: 48,
                          width: 48,
                          child: Icon(isHead ? Icons.star_rounded : Icons.person_rounded, color: isHead ? AppTheme.green2 : AppTheme.gray5, size: 24)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(member.fullName.isNotEmpty ? member.fullName : 'Unnamed Member', style: const TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(member.relationship.isNotEmpty ? member.relationship : 'No relationship set', style: const TextStyle(color: AppTheme.gray5, fontSize: 14)),
                        if (member.mobile.isNotEmpty) ...[const SizedBox(height: 2), Text(member.mobile, style: const TextStyle(color: AppTheme.gray5, fontSize: 13))]
                      ])),
                      IconButton(color: AppTheme.green2, icon: const Icon(Icons.edit_rounded), onPressed: onTap, tooltip: 'Edit member'),
                      const SizedBox(width: 6),
                      IconButton(color: AppTheme.red, icon: const Icon(Icons.delete_rounded), onPressed: onRemove, tooltip: 'Remove member')
                    ])))));
  }
}
