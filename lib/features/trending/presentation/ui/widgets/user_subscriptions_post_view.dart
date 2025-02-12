import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/features/trending/presentation/ui/widgets/top_post_comments_bottom_sheet.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../home_page/data/model/comments_model.dart';
import '../../../../home_page/data/model/emoji_model.dart';

class UserSubscriptionsPostView extends StatefulWidget {
  final String id;
  final String postAlsha;
  final String postUsername;
  final String postUserImage;
  final String loggedInUserName;
  final String loggedInUserImage;
  final String time;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  final double statusBarHeight;
  int index;
  UserSubscriptionsPostView({
    super.key,
    required this.id,
    required this.postAlsha,
    required this.postUsername,
    required this.postUserImage,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.emojisList,
    required this.commentsList,
    required this.statusBarHeight,
    required this.time,
    required this.index,
  });

  @override
  State<UserSubscriptionsPostView> createState() => _UserSubscriptionsPostViewState();
}

class _UserSubscriptionsPostViewState extends State<UserSubscriptionsPostView> {
  String timeAgoText = "";
  double reactPosition = 20.0;
  bool userReacted = false;

  @override
  void initState() {
    List<int> postTime = splitDateTime(widget.time);
    timeAgoText = timeAgo(DateTime(
        postTime[0], postTime[1], postTime[2], postTime[3], postTime[4]));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(8.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 25.r,
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
                                            errorWidget: (context, url,
                                                error) =>
                                                Image.asset(
                                                    AppAssets.profile),
                                            imageUrl:
                                            widget.postUserImage,
                                          ),
                                        ))),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context)
                                          .width *
                                          0.50,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.postUsername,
                                              style: AppTypography.kBold14
                                                  .copyWith(
                                                  color: AppColors
                                                      .cTitle),
                                              overflow:
                                              TextOverflow.ellipsis,
                                              textDirection:
                                              TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        timeAgoText,
                                        style: AppTypography.kLight12
                                            .copyWith(
                                            color: AppColors.greyDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ReadMoreText(
                              widget.postAlsha,
                              style: AppTypography.kLight14.copyWith(fontFamily: "Cairo"),
                              trimLines: 3,
                              colorClickableText: AppColors.cTitle,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: AppStrings.readMore,
                              trimExpandedText: AppStrings.less,
                            ),
                          ],
                        )),
                  ],
                ),
                widget.commentsList.isNotEmpty || widget.emojisList.isNotEmpty ? Divider(
                  color: AppColors.grey,
                ) : SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: widget.commentsList.isNotEmpty || widget.emojisList.isNotEmpty ? 40.h : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.commentsList.isNotEmpty
                          ? Bounceable(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            constraints: BoxConstraints.expand(
                                height: MediaQuery.sizeOf(context)
                                    .height -
                                    widget.statusBarHeight -
                                    50.h,
                                width:
                                MediaQuery.sizeOf(context).width),
                            isScrollControlled: true,
                            barrierColor: AppColors.cTransparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.r),
                              ),
                            ),
                            builder: (context2) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: TopPostCommentsBottomSheet(
                                    postAlsha: widget.postAlsha,
                                    userImage:
                                    widget.loggedInUserImage,
                                    userName: widget.loggedInUserName,
                                    postId: widget.id,
                                    statusBarHeight:
                                    widget.statusBarHeight,
                                    commentsList:
                                    widget.commentsList,
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              widget.commentsList.length.toString(),
                              style: AppTypography.kLight14,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              widget.commentsList.length > 1 && widget.commentsList.length < 11 ? AppStrings.comments : AppStrings.comment,
                              style: AppTypography.kBold14
                                  .copyWith(color: AppColors.cTitle),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                      widget.emojisList.isNotEmpty
                          ? Row(
                        children: [
                          Text(
                            widget.emojisList[0].username,
                            style: AppTypography.kLight14.copyWith(color: AppColors.cSecondary),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          SizedBox(
                            width: 35.w,
                            height: 30.h,
                            child: Stack(
                              children: widget.emojisList
                                  .asMap()
                                  .entries
                                  .toList()
                                  .fold<
                                  List<
                                      MapEntry<int,
                                          dynamic>>>([],
                                      (acc, entry) {
                                    if (!acc.any((e) =>
                                    e.value.emojiData ==
                                        entry.value.emojiData)) {
                                      acc.add(entry);
                                    }
                                    return acc;
                                  }).map((entry) {
                                int index =
                                    entry.key; // Original index
                                return Positioned(
                                  left: index * reactPosition,
                                  child: CircleAvatar(
                                    radius: 15.r,
                                    backgroundColor:
                                    AppColors.cWhite,
                                    child: Container(
                                      padding: EdgeInsets.all(1.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                          AppColors.cSecondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Text(
                                          entry.value.emojiData,
                                          style: AppTypography
                                              .kExtraLight18,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                const CardDivider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
