import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../../../core/utils/constant/app_assets.dart';
import '../../../../../../core/utils/style/app_colors.dart';
import '../../../../../../core/utils/ui_components/tab_icon.dart';

class MessagesTab extends StatelessWidget {
  int selectScreen;
  List<bool> selectedWidgets;
  bool messagesBadge;
  int messagesBadgeAmount;
  MessagesTab({super.key, required this.selectedWidgets, required this.selectScreen, required this.messagesBadge, required this.messagesBadgeAmount});

  @override
  Widget build(BuildContext context) {
    return messagesBadgeAmount > 0
        ? badges.Badge(
      position: badges.BadgePosition.topStart(
          top: 0, start: 0),
      badgeAnimation:
      const badges.BadgeAnimation.slide(
        disappearanceFadeAnimationDuration:
        Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      ),
      showBadge: messagesBadge,
      badgeStyle: const badges.BadgeStyle(
        badgeColor: AppColors.cPrimary,
      ),
      badgeContent: Text(
        messagesBadgeAmount > 50
            ? '+50'
            : messagesBadgeAmount.toString(),
        style:
        const TextStyle(color: AppColors.cWhite),
      ),
      child: TabIcon(
        selectedWidgets: selectedWidgets,
        selectScreen: selectScreen,
        index: 5,
        heightSize: 50.h,
        widthSize: 50.w,
        blueIcon: AppAssets.message,
        whiteIcon: AppAssets.messageWhite,
        padding: 5.w,
      ),
    )
        : TabIcon(
      selectedWidgets: selectedWidgets,
      selectScreen: selectScreen,
      index: 5,
      heightSize: 50.h,
      widthSize: 50.w,
      blueIcon: AppAssets.message,
      whiteIcon: AppAssets.messageWhite,
      padding: 5.w,
    );
  }
}
