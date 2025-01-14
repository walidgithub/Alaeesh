import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/core/utils/constant/app_assets.dart';
import 'package:last/core/utils/constant/app_typography.dart';
import 'package:launch_app_store/launch_app_store.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/style/app_colors.dart';

class DrawerInfo extends StatefulWidget {
  const DrawerInfo({super.key});

  @override
  State<DrawerInfo> createState() => _DrawerInfoState();
}

class _DrawerInfoState extends State<DrawerInfo> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cWhite,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppStrings.about, style: AppTypography.kBold18.copyWith(color: AppColors.cSecondary),),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  AppStrings.info,
                  style: TextStyle(fontSize: 15.sp, color: AppColors.cBlack),textDirection: TextDirection.rtl,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Column(
                    children: [
                      Text(AppStrings.rating, style: AppTypography.kBold18.copyWith(color: AppColors.cSecondary),),
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      Bounceable(
                        onTap: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 700));
                          LaunchReview.launch(androidAppId: "com.iyaffle.kural");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
