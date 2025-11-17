import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class FamilyMemberCard extends StatelessWidget {
  final int index;
  final dynamic member;
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
        color: isHead
            ? AppTheme.primaryColor.withOpacity(0.05)
            : AppTheme.scaffoldBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHead ? AppTheme.primaryColor : AppTheme.borderColor,
          width: isHead ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isHead
                        ? AppTheme.primaryColor.withOpacity(0.15)
                        : AppTheme.checkboxUnselectedBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    isHead ? Icons.star_rounded : Icons.person_rounded,
                    color:
                        isHead ? AppTheme.primaryColor : AppTheme.iconSecondary,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.relationship.isNotEmpty
                            ? member.relationship
                            : 'No relationship set',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (member.mobile.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          member.mobile,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded),
                  color: AppTheme.errorColor,
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