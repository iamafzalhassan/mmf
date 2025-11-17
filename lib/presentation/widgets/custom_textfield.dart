import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ) ??
                  const TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontSize: 14,
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
                            ) ??
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
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            suffixIconColor: AppTheme.iconSecondary,
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            counterText: '',
          ),
          onChanged: onChanged,
          validator: validator ??
              (isRequired
                  ? (val) => (val == null || val.isEmpty)
                      ? 'This field is required'
                      : null
                  : null),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
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
}
