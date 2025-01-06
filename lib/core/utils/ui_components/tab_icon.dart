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
  double? widthSize;
  double? heightSize;
  double? padding;
  TabIcon({super.key, required this.selectedWidgets, required this.selectScreen, required this.index, required this.blueIcon, required this.whiteIcon, this.widthSize, this.heightSize, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 0),
      height: heightSize ?? 50.h,
      width: widthSize ?? 50.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedWidgets[index] ? AppColors.cTitle : AppColors.cWhite
      ),
      child: SvgPicture.asset(selectedWidgets[index] ? whiteIcon : blueIcon),
    );
  }
}