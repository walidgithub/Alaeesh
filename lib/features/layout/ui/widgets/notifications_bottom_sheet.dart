import 'package:alaeeeesh/core/utils/constant/app_assets.dart';
import 'package:alaeeeesh/core/utils/constant/app_constants.dart';
import 'package:alaeeeesh/core/utils/style/app_colors.dart';
import 'package:alaeeeesh/features/home_page/data/model/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../core/utils/ui_components/post/post_view.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../data/model/notifications_model.dart';

class NotificationsBottomSheet extends StatefulWidget {
  double statusBarHeight;
  NotificationsBottomSheet({super.key, required this.statusBarHeight});

  @override
  State<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.sizeOf(context).height - widget.statusBarHeight,
          padding: EdgeInsets.all(20.h),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              color: AppColors.cWhite,
              border: Border.all(color: AppColors.cTitle, width: 1.5.w),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomDivider(),
              const Divider(
                color: AppColors.grey,
              ),
              SizedBox(height: AppConstants.heightBetweenElements),
              Center(
                child: Text(AppStrings.notifications,
                    style: AppTypography.kBold24
                        .copyWith(color: AppColors.cTitle)),
              ),
              SizedBox(
                height: AppConstants.moreHeightBetweenElements,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PostView(
                                id: notificationsModel[index].postModel.id,
                                time: notificationsModel[index].postModel.time,
                                username: notificationsModel[index]
                                    .postModel
                                    .username,
                                userImage: notificationsModel[index]
                                    .postModel
                                    .userImage,
                                postAlsha: notificationsModel[index]
                                    .postModel
                                    .postAlsha,
                                emojisList: notificationsModel[index]
                                    .postModel
                                    .emojisList,
                                commentsList: notificationsModel[index]
                                    .postModel
                                    .commentsList,
                                emojiDataCount: notificationsModel[index]
                                    .postModel
                                    .emojiDataCount,
                                statusBarHeight: widget.statusBarHeight);
                          },
                          itemCount: notificationsModel.length)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
