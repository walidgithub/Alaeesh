import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constant/app_assets.dart';
import '../../../../../../core/utils/ui_components/tab_icon.dart';

class TrendingTab extends StatelessWidget {
  Function goTo;
  int selectScreen;
  List<bool> selectedWidgets;
  TrendingTab({super.key, required this.goTo, required this.selectScreen, required this.selectedWidgets});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          goTo();
        },
        child: TabIcon(
          selectedWidgets: selectedWidgets,
          selectScreen: selectScreen,
          index: 2,
          heightSize: 50.h,
          widthSize: 50.w,
          blueIcon: AppAssets.trending,
          whiteIcon: AppAssets.trendingWhite,
          padding: 7.w,
        ));
  }
}
