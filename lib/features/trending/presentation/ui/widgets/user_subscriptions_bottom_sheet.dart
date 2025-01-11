import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/features/trending/presentation/ui/widgets/top_post_comments_bottom_sheet.dart';
import 'package:last/features/trending/presentation/ui/widgets/user_subscriptions_post_view.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../home_page/data/model/comments_model.dart';
import '../../../../home_page/data/model/emoji_model.dart';
import '../../../../home_page/data/model/home_page_model.dart';
import '../../../../home_page/data/model/post_subscribers_model.dart';
import '../../../../home_page/presentation/ui/widgets/reactions_bottom_sheet.dart';

class UserSubscriptionsBottomSheet extends StatefulWidget {
  List<HomePageModel> homePageModel;
  final String postUsername;
  final String postUserImage;
  final String loggedInUserName;
  final String loggedInUserImage;
  final double statusBarHeight;
  Function getUserPosts;
  Function addOrRemoveSubscriber;
  UserSubscriptionsBottomSheet({
    super.key,
    required this.homePageModel,
    required this.postUsername,
    required this.postUserImage,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.statusBarHeight,
    required this.getUserPosts,
    required this.addOrRemoveSubscriber,
  });

  @override
  State<UserSubscriptionsBottomSheet> createState() => _UserSubscriptionsBottomSheetState();
}

class _UserSubscriptionsBottomSheetState extends State<UserSubscriptionsBottomSheet> {
  bool userSubscribed = false;
  @override
  void initState() {
    userSubscribed = widget.homePageModel[0].userSubscribed;
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
                  child: Text(AppStrings.userSubscriptions,
                      style:
                      AppTypography.kBold24.copyWith(color: AppColors.cTitle)),
                ),
                SizedBox(
                  height: AppConstants.moreHeightBetweenElements,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.loggedInUserName !=
                        widget.postUsername
                        ? GestureDetector(
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
                        : Container(),
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
                                  postUsername: widget.postUsername,
                                  postUserImage: widget.postUserImage,
                                  loggedInUserName: widget.loggedInUserName,
                                  loggedInUserImage: widget.loggedInUserImage,
                                  emojisList: widget.homePageModel[index].postModel.emojisList,
                                  commentsList: widget.homePageModel[index].postModel.commentsList,
                                  statusBarHeight: widget.statusBarHeight,
                                  time: widget.homePageModel[0].postModel.time,
                                  index: 0,
                                  userSubscribed: widget.homePageModel[index].userSubscribed,
                                  getUserPosts: (String username) {
                                    widget.getUserPosts(username);
                                  });
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
