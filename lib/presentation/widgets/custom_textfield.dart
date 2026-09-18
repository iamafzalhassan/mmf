import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key, this.isRequired = false, this.readOnly = false, required this.label, this.hintText, this.initialValue, this.inputFormatters, this.validator, this.keyboardType, this.onChanged, this.onTap, this.suffixIcon});

  final bool isRequired;
  final bool readOnly;

  final String label;
  final String? hintText;
  final String? initialValue;

  final List<TextInputFormatter>? inputFormatters;

  final FormFieldValidator<String>? validator;

  final TextInputType? keyboardType;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(TextSpan(
            style: const TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.w500), text: label, children: [if (isRequired) const TextSpan(style: TextStyle(color: AppTheme.red, fontWeight: FontWeight.w600), text: ' *')])),
        const SizedBox(height: 8),
        TextFormField(
            decoration: InputDecoration(hintText: hintText, suffixIcon: suffixIcon, suffixIconColor: AppTheme.gray5),
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            style: const TextStyle(color: AppTheme.black, fontFamily: AppTheme.fontFamily, fontSize: 16, fontWeight: FontWeight.w400),
            validator: validator ?? (isRequired ? (value) => (value?.isEmpty ?? true) ? 'This field is required' : null : null))
      ]);
}
