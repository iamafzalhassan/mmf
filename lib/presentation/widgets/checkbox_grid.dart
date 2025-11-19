import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CheckboxGrid extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<String> items;
  final List<String> selectedItems;

  const CheckboxGrid({
    super.key,
    required this.onChanged,
    required this.items,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(item),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                width: isSelected ? 2 : 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.15) : AppTheme.cardBackground,
            ),
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.transparent,
                  ),
                  duration: const Duration(milliseconds: 200),
                  height: 20,
                  width: 20,
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppTheme.textOnPrimary,
                          size: 14,
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    fontFamily: 'SFProDisplay',
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}