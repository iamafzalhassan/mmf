import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'package:mmf/presentation/widgets/custom_textfield.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key, this.isRequired = false, required this.label, required this.value, required this.items, required this.onChanged});

  final bool isRequired;

  final String label;
  final String value;

  final List<String> items;

  final ValueChanged<String> onChanged;

  Widget buildSheet(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: AppTheme.gray3), height: 4, margin: const EdgeInsets.only(bottom: 16), width: 40),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Text(label, style: const TextStyle(color: AppTheme.black, fontFamily: AppTheme.fontFamily, fontSize: 18, fontWeight: FontWeight.w600))])),
        const SizedBox(height: 16),
        const Divider(height: 0),
        Flexible(child: ListView(shrinkWrap: true, children: [for (final item in items) buildOption(context, item)]))
      ]));

  Widget buildOption(BuildContext context, String item) {
    final isSelected = item == value;
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        onTap: () {
          onChanged(item);
          Navigator.pop(context);
        },
        title: Text(item, style: TextStyle(color: isSelected ? AppTheme.green2 : AppTheme.black, fontFamily: AppTheme.fontFamily, fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.green2, size: 24) : null);
  }

  @override
  Widget build(BuildContext context) => CustomTextField(
      key: ValueKey(value),
      hintText: 'Select ${label.toLowerCase()}',
      initialValue: value,
      isRequired: isRequired,
      label: label,
      onTap: () => showModalBottomSheet(backgroundColor: AppTheme.white1, builder: buildSheet, context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12)))),
      readOnly: true,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined, color: AppTheme.gray5, size: 20));
}
