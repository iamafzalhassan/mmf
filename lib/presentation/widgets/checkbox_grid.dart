import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CheckboxGrid extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<String> onChanged;

  const CheckboxGrid({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return InkWell(
          onTap: () => onChanged(item),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : AppTheme.checkboxUnselectedBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : AppTheme.borderColor,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 20,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AppTheme.iconSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppTheme.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
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