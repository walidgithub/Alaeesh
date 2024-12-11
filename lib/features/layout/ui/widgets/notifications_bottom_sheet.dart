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

class NotificationsBottomSheet extends StatefulWidget {
  double statusBarHeight;
  NotificationsBottomSheet({super.key, required this.statusBarHeight});

  @override
  State<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState extends State<NotificationsBottomSheet> {
  List<PostModel> postModel = [
    PostModel(
        id: 1,
        emojiDataCount: 0,
        postAlsha:
            " الشة رقم 1 الشة رقم 1الشة رقم 1الشة رقم 1 الشة رقم 1 الشة رقم 1 الشة رقم 1",
        username: "walid111",
        commentsList: [CommentsModel(id: 1, postId: 1, username: "walid2222", userImage: AppAssets.profile.toString(), time: "2h", comment: "التعليقاتتتتتتتتت",emojiDataCount: 0,emojisList: [])],
        userImage: AppAssets.profile.toString(),
        emojisList: [],
        time: "2h"),
    PostModel(
        id: 2,
        emojiDataCount: 0,
        postAlsha:
            " الشة رقم 2 الشة رقم 2الشة رقم 2الشة رقم 2 الشة رقم 2 الشة رقم 2 الشة رقم 2",
        username: "walid2222",
        commentsList: [],
        userImage: AppAssets.profile.toString(),
        emojisList: [],
        time: "3h"),
  ];

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
                                id: postModel[index].id,
                                time: postModel[index].time,
                                username: postModel[index].username,
                                userImage: postModel[index].userImage,
                                postAlsha: postModel[index].postAlsha,
                                emojisList: postModel[index].emojisList,
                                commentsList: postModel[index].commentsList,
emojiDataCount: postModel[index].emojiDataCount,
                                statusBarHeight: widget.statusBarHeight);
                          },
                          itemCount: postModel.length)
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
