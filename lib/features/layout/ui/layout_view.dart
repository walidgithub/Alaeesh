import 'package:alaeeeesh/core/utils/constant/app_assets.dart';
import 'package:alaeeeesh/core/utils/constant/app_strings.dart';
import 'package:alaeeeesh/core/utils/constant/app_typography.dart';
import 'package:alaeeeesh/core/utils/style/app_colors.dart';
import 'package:alaeeeesh/features/home_page/presentation/ui/home_view.dart';
import 'package:alaeeeesh/features/layout/ui/widgets/add_post_bottom_sheet.dart';
import 'package:alaeeeesh/features/layout/ui/widgets/notifications_bottom_sheet.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../core/utils/dialogs/back_dialog.dart';
import '../../../../core/utils/ui_components/tab_icon.dart';
import '../../../core/utils/constant/app_constants.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  String username = "بـالـزائـر";
  final int _notificationBadgeAmount = 0;
  bool _showNotificationBadge = true;

  List<Widget> screens = [
    const HomeView(),
    const HomeView(),
  ];

  List<bool> selectedWidgets = [true, false];
  int selectScreen = 0;
  void toggleIcon(int index) {
    setState(() {
      for (int i = 0; i < selectedWidgets.length; i++) {
        selectedWidgets[i] = false;
      }
      selectedWidgets[index] = true;
      selectScreen = index;
    });
  }

  @override
  void initState() {
    toggleIcon(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: SafeArea(
          child: Scaffold(
            body: Directionality(
                textDirection: TextDirection.rtl, child: bodyContent(context, statusBarHeight)),
          )),
    );
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            screens[selectScreen],
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeInRight(
                        duration: Duration(milliseconds: AppConstants.animation),
                        child: Row(
                          children: [
                            Bounceable(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints.expand(
                                      height: MediaQuery.sizeOf(context).height - statusBarHeight - 100.h,
                                      width: MediaQuery.sizeOf(context).width
                                  ),
                                  isScrollControlled: true,
                                  barrierColor: AppColors.cTransparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.r),
                                    ),
                                  ),
                                  builder: (context2) {
                                    return NotificationsBottomSheet(statusBarHeight: statusBarHeight,);
                                  },
                                );
                              },
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -15, end: 0),
                                badgeAnimation: const badges.BadgeAnimation.slide(
                                  disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut,
                                ),
                                showBadge: _showNotificationBadge,
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: AppColors.cPrimary,
                                ),
                                badgeContent: Text(
                                  _notificationBadgeAmount.toString(),
                                  style: const TextStyle(color: AppColors.cWhite),
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.notification,
                                  width: 30.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Bounceable(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints.expand(
                                    height: MediaQuery.sizeOf(context).height - statusBarHeight - 100.h,
                                    width: MediaQuery.sizeOf(context).width
                                  ),
                                  isScrollControlled: true,
                                  barrierColor: AppColors.cTransparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.r),
                                    ),
                                  ),
                                  builder: (context2) {
                                    return AddPostBottomSheet(statusBarHeight: statusBarHeight,);
                                  },
                                );
                              },
                              child: SvgPicture.asset(
                                AppAssets.addPost,
                                width: 30.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: AppConstants.animation),
                        child: Row(
                          children: [
                            Text('${AppStrings.hello} $username',style: AppTypography.kBold16.copyWith(color: AppColors.cTitle),),
                            SizedBox(width: 10.w,),
                            CircleAvatar(
                                radius: 30.r,
                                backgroundColor: AppColors.cWhite,
                                child: ClipOval(
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.cTitle,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(AppAssets.profile,width: 70.w,),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.grey,)
                ],
              ),
            ),
            Positioned(
              bottom: 5.h,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width - 20.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          toggleIcon(1);
                        },
                        child: TabIcon(
                          selectedWidgets: selectedWidgets,
                          selectScreen: selectScreen,
                          index: 1,
                          blueIcon: AppAssets.activity,
                          whiteIcon: AppAssets.activityWhite,
                        )),
                    GestureDetector(
                        onTap: () {
                          toggleIcon(0);
                        },
                        child: TabIcon(
                          selectedWidgets: selectedWidgets,
                          selectScreen: selectScreen,
                          index: 0,
                          blueIcon: AppAssets.home,
                          whiteIcon: AppAssets.homeWhite,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
