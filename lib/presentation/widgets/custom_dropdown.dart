import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final bool isRequired;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final List<String> items;

  const CustomDropdown({
    super.key,
    this.isRequired = false,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ) ??
                      const TextStyle(
                        color: AppTheme.black,
                        fontFamily: 'SFProDisplay',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                  text: label,
                ),
                if (isRequired)
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(
                          color: AppTheme.red,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                        ),
                    text: ' *',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: TextEditingController(text: value.isEmpty ? '' : value),
          decoration: InputDecoration(
            hintText: 'Select ${label.toLowerCase()}',
            suffixIcon: Icon(
              Icons.arrow_drop_down_circle_outlined,
              color: AppTheme.gray6,
              size: 20,
            ),
          ),
          onTap: () => showModalBottomSheet(
            backgroundColor: AppTheme.white1,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            builder: (context) => Container(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppTheme.gray2,
                    ),
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: AppTheme.black,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 0),
                  Flexible(
                    child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = value == item;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          onTap: () {
                            onChanged(item);
                            Navigator.pop(context);
                          },
                          title: Text(
                            item,
                            style: TextStyle(
                              color: isSelected ? AppTheme.green2 : AppTheme.black,
                              fontFamily: 'SFProDisplay',
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.green2,
                                  size: 24,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          readOnly: true,
          style: const TextStyle(
            color: AppTheme.black,
            fontFamily: 'SFProDisplay',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          validator: isRequired ? (val) => (val == null || val.isEmpty) ? 'This field is required' : null : null,
        ),
      ],
    );
  }
}