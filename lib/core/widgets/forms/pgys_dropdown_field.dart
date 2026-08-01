import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_colors.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_radius.dart';
import 'package:personel_gorev_yonetim_sistemi/core/theme/app_sizes.dart';

class PGYSDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  //final double width;
  final String Function(T item)? labelBuilder;

  const PGYSDropdownField({
    super.key,
    required this.items,
    required this.hint,
    this.value,
    this.onChanged,
    //this.width = 280,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: width,
      height: AppSizes.buttonHeight,

      child: DropdownButtonFormField<T>(
        isExpanded: true,
        initialValue: value,

        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
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
        onChanged: onChanged,
        decoration: InputDecoration(
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
        hint: Text(hint),
      ),
    );
  }
}
