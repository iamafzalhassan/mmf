import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmf/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final bool isRequired;
  final bool obscureText;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final String label;
  final String? hintText;
  final String? initialValue;
  final String? prefixText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.isRequired = false,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    required this.label,
    this.hintText,
    this.initialValue,
    this.prefixText,
    this.validator,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
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
          controller: controller,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            prefixIcon: prefixIcon,
            prefixStyle: const TextStyle(
              color: AppTheme.black,
              fontFamily: 'SFProDisplay',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            prefixText: prefixText,
            suffixIcon: suffixIcon,
            suffixIconColor: AppTheme.gray6,
          ),
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          obscureText: obscureText,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          style: const TextStyle(
            color: AppTheme.black,
            fontFamily: 'SFProDisplay',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          validator: validator ?? (isRequired ? (val) => (val == null || val.isEmpty) ? 'This field is required' : null : null),
        ),
      ],
    );
  }
}