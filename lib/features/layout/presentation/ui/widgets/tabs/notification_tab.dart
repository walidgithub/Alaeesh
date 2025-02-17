import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../../../core/utils/constant/app_assets.dart';
import '../../../../../../core/utils/style/app_colors.dart';
import '../../../../../../core/utils/ui_components/tab_icon.dart';

class NotificationTab extends StatelessWidget {
  int selectScreen;
  List<bool> selectedWidgets;
  bool notificationsBadge;
  int notificationsBadgeAmount;
  NotificationTab({super.key, required this.selectedWidgets, required this.selectScreen, required this.notificationsBadge, required this.notificationsBadgeAmount});

  @override
  Widget build(BuildContext context) {
    return notificationsBadgeAmount > 0 ? badges.Badge(
      position: badges.BadgePosition.topStart(
          top: 0, start: 0),
      badgeAnimation:
      const badges.BadgeAnimation.slide(
        disappearanceFadeAnimationDuration:
        Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      ),
      showBadge: notificationsBadge,
      badgeStyle: badges.BadgeStyle(
        badgeColor: AppColors.cPrimary,
      ),
      badgeContent: Text(
        notificationsBadgeAmount > 50
            ? '+50'
            : notificationsBadgeAmount.toString(),
        style:
        const TextStyle(color: AppColors.cWhite),
      ),
      child: TabIcon(
        selectedWidgets: selectedWidgets,
        selectScreen: selectScreen,
        index: 3,
        heightSize: 50.h,
        widthSize: 50.w,
        blueIcon: AppAssets.notification,
        whiteIcon: AppAssets.notificationWhite,
        padding: 7.w,
      ),
    ) : TabIcon(
      selectedWidgets: selectedWidgets,
      selectScreen: selectScreen,
      index: 3,
      heightSize: 50.h,
      widthSize: 50.w,
      blueIcon: AppAssets.notification,
      whiteIcon: AppAssets.notificationWhite,
      padding: 7.w,
    );
  }
}
