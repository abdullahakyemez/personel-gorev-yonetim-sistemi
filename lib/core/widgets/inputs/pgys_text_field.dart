import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';

class PGYSTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;
  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  final TextInputAction textInputAction;

  const PGYSTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.autoFocus = false,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        inputFormatters: inputFormatters,
        autofocus: autoFocus,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enabled: enabled,
        maxLines: maxLines,
        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,

          filled: true,
          fillColor: AppColors.surface,

          border: OutlineInputBorder(borderRadius: AppRadius.mdRadius),

          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdRadius,
            borderSide: BorderSide(color: AppColors.border),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdRadius,
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
