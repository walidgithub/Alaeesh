import 'package:flutter/material.dart';

import '../constant/app_typography.dart';
import '../style/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        text,
        style: AppTypography.kLight14.copyWith(
          color: color ?? AppColors.cTitle,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
