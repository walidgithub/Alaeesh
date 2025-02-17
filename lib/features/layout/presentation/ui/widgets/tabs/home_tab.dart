import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constant/app_assets.dart';
import '../../../../../../core/utils/ui_components/tab_icon.dart';

class HomeTab extends StatelessWidget {
  Function goTo;
  int selectScreen;
  List<bool> selectedWidgets;
  HomeTab({super.key, required this.goTo, required this.selectScreen, required this.selectedWidgets});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
         goTo();
        },
        child: TabIcon(
          selectedWidgets: selectedWidgets,
          selectScreen: selectScreen,
          index: 0,
          blueIcon: AppAssets.home,
          whiteIcon: AppAssets.homeWhite,
          padding: 2.w,
        ));
  }
}
