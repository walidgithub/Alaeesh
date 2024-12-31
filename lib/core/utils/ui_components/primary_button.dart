import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_constants.dart';
import '../constant/app_typography.dart';
import '../style/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? borderColor;
  final Color? textColor;
  final Widget? child;
  final bool? gradient;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
    this.borderColor,
    this.textColor,
    this.child,
    this.gradient,
    super.key,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: widget.height ?? 55.h,
        alignment: Alignment.center,
        width: widget.width ?? double.maxFinite,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
         gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: widget.gradient! ? [
              AppColors.cTitle,
              AppColors.cYellow,
            ] : [AppColors.cWhite,AppColors.cWhite],
          ),
            border: Border.all(color: widget.gradient! ? AppColors.cWhite : AppColors.cTitle),
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppConstants.radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: AppTypography.kMedium15.copyWith(
                color: widget.gradient! ? AppColors.cWhite : AppColors.cTitle,
                fontSize: widget.fontSize ?? 20.sp,
              ),
            ),
            widget.child != null ? SizedBox(width: 5.w,) : const SizedBox.shrink(),
            widget.child ?? const Text("")
          ],
        ),
      ),
    );
  }
}
