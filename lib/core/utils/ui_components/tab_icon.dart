import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../style/app_colors.dart';

class TabIcon extends StatelessWidget {
  List<bool> selectedWidgets;
  int selectScreen;
  int index;
  String whiteIcon;
  String blueIcon;
  TabIcon({super.key, required this.selectedWidgets, required this.selectScreen, required this.index, required this.blueIcon, required this.whiteIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedWidgets[index] ? AppColors.cTitle : AppColors.cWhite
      ),
      child: SvgPicture.asset(selectedWidgets[index] ? whiteIcon : blueIcon),
    );
  }
}