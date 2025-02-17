import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../functions/show_user_popup_menu.dart';

class ProfileDataView extends StatelessWidget {
  Function showUserPopupMenu;
  String displayName;
  String photoUrl;
  ProfileDataView({super.key, required this.showUserPopupMenu, required this.displayName, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(AppStrings.hello,
                    style: AppTypography.kBold14
                        .copyWith(color: AppColors.cTitle)),
                Flexible(
                  child: Text(
                    displayName,
                    style: AppTypography.kBold14
                        .copyWith(color: AppColors.cTitle),
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Bounceable(
              onTap: () {
                showUserPopupMenu();
              },
              child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.cWhite,
                  child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cTitle,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: AppColors.cTitle,
                              ),
                          errorWidget: (context, url, error) =>
                              Image.asset(AppAssets.profile),
                          imageUrl: photoUrl,
                        ),
                      )))),
        ],
      ),
    );
  }
}
