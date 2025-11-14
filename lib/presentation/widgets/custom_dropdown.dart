import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isRequired;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: value.isEmpty ? '' : value),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.iconSecondary,
              size: 24,
            ),
            hintText: 'Select ${label.toLowerCase()}',
          ),
          onTap: () => _showBottomSheet(context),
          validator: isRequired
              ? (val) => (val == null || val.isEmpty) ? 'This field is required' : null
              : null,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = value == item;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.primaryColor,
                      size: 24,
                    )
                        : null,
                    onTap: () {
                      onChanged(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}