import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';

class PGYSDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  //final double width;
  final String Function(T item)? labelBuilder;
  final String? label;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool enabled;
  final FormFieldSetter<T>? onSaved;

  const PGYSDropdownField({
    super.key,
    required this.items,
    required this.hint,
    this.value,
    this.onChanged,
    //this.width = 280,
    this.labelBuilder,
    this.label,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: width,
      height: AppSizes.buttonHeight,

      child: DropdownButtonFormField<T>(
        isExpanded: true,
        initialValue: value,
        dropdownColor: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),

        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            enabled: enabled,
            child: Tooltip(
              message: labelBuilder?.call(item) ?? item.toString(),
              child: Text(
                labelBuilder?.call(item) ?? item.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        }).toList(),

        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(borderRadius: AppRadius.mdRadius),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdRadius,
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.mdRadius,
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
          ),
        ),
        hint: Text(hint),
      ),
    );
  }
}
