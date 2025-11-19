import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/domain/entities/family_member.dart';

class FamilyMemberCard extends StatelessWidget {
  final int index;
  final FamilyMember member;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FamilyMemberCard({
    super.key,
    required this.index,
    required this.member,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isHead = member.relationship == 'Head of Family';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isHead ? AppTheme.primaryColor : AppTheme.borderColor,
          width: isHead ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isHead ? AppTheme.primaryColor.withOpacity(0.05) : AppTheme.scaffoldBackground.withOpacity(0.3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: isHead ? AppTheme.primaryColor.withOpacity(0.15) : AppTheme.checkboxUnselectedBackground,
                  ),
                  height: 48,
                  width: 48,
                  child: Icon(
                    isHead ? Icons.star_rounded : Icons.person_rounded,
                    color: isHead ? AppTheme.primaryColor : AppTheme.iconSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name.isNotEmpty ? member.name : 'Unnamed Member',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.relationship.isNotEmpty ? member.relationship : 'No relationship set',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (member.mobile.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          member.mobile,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  color: AppTheme.errorColor,
                  icon: const Icon(Icons.delete_rounded),
                  onPressed: onRemove,
                  tooltip: 'Remove member',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}