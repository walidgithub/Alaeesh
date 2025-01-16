import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/core/utils/constant/app_strings.dart';
import 'package:last/core/utils/constant/app_typography.dart';

import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/style/app_colors.dart';

class SuggestedUserView extends StatefulWidget {
  String userImage;
  String userName;
  int subscriptionsCount;
  Function getUserPosts;
  SuggestedUserView({super.key, required this.userName, required this.userImage, required this.getUserPosts, required this.subscriptionsCount});

  @override
  State<SuggestedUserView> createState() => _SuggestedUserViewState();
}

class _SuggestedUserViewState extends State<SuggestedUserView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Bounceable(
          onTap: () {
            widget.getUserPosts();
          },
          child: Container(
            width: 160.w,
            height: 160.h,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.cSecondary),
                borderRadius: BorderRadius.all(Radius.circular(10.r))),
            child: Column(
              children: [
                CircleAvatar(
                    radius: 60.r,
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
                            imageUrl:
                            widget.userImage,
                          ),
                        ))),
                Flexible(child: Text(widget.userName, style: AppTypography.kLight14.copyWith(color: AppColors.cTitle),overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,),),
                Text("${widget.subscriptionsCount > 50 ? AppStrings.moreThan : ''} ${widget.subscriptionsCount > 50 ? 50 : widget.subscriptionsCount} ${widget.subscriptionsCount > 10 ? AppStrings.subscription : AppStrings.subscriptions}", style: AppTypography.kLight13.copyWith(color: AppColors.grey),)
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }
}
