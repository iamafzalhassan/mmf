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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ) ??
                  const TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16) ??
                        const TextStyle(
                          fontFamily: 'SFProDisplay',
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
              Icons.arrow_drop_down_circle_outlined,
              color: AppTheme.iconSecondary,
              size: 20,
            ),
            hintText: 'Select ${label.toLowerCase()}',
          ),
          onTap: () => _showBottomSheet(context),
          validator: isRequired
              ? (val) =>
                  (val == null || val.isEmpty) ? 'This field is required' : null
              : null,
          style: const TextStyle(
            fontFamily: 'SFProDisplay',
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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 0),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = value == item;
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
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
          ],
        ),
      ),
    );
  }
}