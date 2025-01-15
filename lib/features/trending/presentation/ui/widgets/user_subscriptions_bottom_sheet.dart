import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/features/trending/presentation/ui/widgets/user_subscriptions_post_view.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../home_page/data/model/home_page_model.dart';

class UserSubscriptionsBottomSheet extends StatefulWidget {
  List<HomePageModel> homePageModel;
  final String loggedInUserName;
  final String loggedInUserImage;
  final String username;
  final double statusBarHeight;
  final bool userSubscribed;
  Function addOrRemoveSubscriber;
  UserSubscriptionsBottomSheet({
    super.key,
    required this.homePageModel,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.username,
    required this.statusBarHeight,
    required this.addOrRemoveSubscriber,
    required this.userSubscribed,
  });

  @override
  State<UserSubscriptionsBottomSheet> createState() => _UserSubscriptionsBottomSheetState();
}

class _UserSubscriptionsBottomSheetState extends State<UserSubscriptionsBottomSheet> {
  bool userSubscribed = false;
  @override
  void initState() {
    userSubscribed = widget.userSubscribed;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
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
                  child: Text(
                    AppStrings.userSubscriptions,
                    style: AppTypography.kBold24
                        .copyWith(color: AppColors.cTitle),
                  ),
                ),
                Center(
                  child: Flexible(
                    child: Text(
                      widget.username,
                      style: AppTypography.kBold18
                          .copyWith(color: AppColors.cTitle),
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppConstants.moreHeightBetweenElements,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (userSubscribed) {
                            widget.addOrRemoveSubscriber(-1);
                          } else {
                            widget.addOrRemoveSubscriber(1);
                          }
                        },
                        child: SvgPicture.asset(
                          userSubscribed
                              ? AppAssets.notificationOn
                              : AppAssets.notificationOff,
                          width: 30.w,
                        ))
                  ],
                ),
                SizedBox(
                  height: AppConstants.moreHeightBetweenElements,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return UserSubscriptionsPostView(
                                  id: widget.homePageModel[index].postModel.id.toString(),
                                  postAlsha: widget.homePageModel[index].postModel.postAlsha,
                                  postUsername: widget.homePageModel[index].postModel.username,
                                  postUserImage: widget.homePageModel[index].postModel.userImage,
                                  loggedInUserName: widget.loggedInUserName,
                                  loggedInUserImage: widget.loggedInUserImage,
                                  emojisList: widget.homePageModel[index].postModel.emojisList,
                                  commentsList: widget.homePageModel[index].postModel.commentsList,
                                  statusBarHeight: widget.statusBarHeight,
                                  time: widget.homePageModel[index].postModel.time,
                                  index: 0,
                                  );
                            },
                            itemCount: widget.homePageModel.length),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
