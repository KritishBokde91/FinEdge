import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable standard text field with clean validation markers and input styles.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final bool isObscured;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    required this.labelText,
    this.controller = null,
    this.hintText = null,
    this.errorText = null,
    this.isObscured = false,
    this.keyboardType = TextInputType.text,
    this.onChanged = null,
    this.validator = null,
    this.inputFormatters = null,
    this.suffixIcon = null,
    this.prefixIcon = null,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.onTap = null,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
