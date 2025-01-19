import 'package:cached_network_image/cached_network_image.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_comment_bottom_sheet.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../home_page/data/model/comment_emoji_model.dart';

class TopPostCommentView extends StatefulWidget {
  final String id;
  final String comment;
  final String username;
  final String userImage;
  final String time;
  final String postId;
  final List<CommentEmojiModel> commentEmojisModel;
  double statusBarHeight;
  final String loggedInUserName;
  final String loggedInUserImage;
  int index;
  TopPostCommentView({
    super.key,
    required this.id,
    required this.comment,
    required this.username,
    required this.userImage,
    required this.time,
    required this.commentEmojisModel,
    required this.statusBarHeight,
    required this.postId,
    required this.index,
    required this.loggedInUserName,
    required this.loggedInUserImage,
  });

  @override
  State<TopPostCommentView> createState() => _TopPostCommentViewState();
}

class _TopPostCommentViewState extends State<TopPostCommentView> {
  double reactPosition = 20.0;
  int reactionsCount = 0;
  String timeAgoText = "";

  @override
  void initState() {
    List<int> postTime = splitDateTime(widget.time);
    timeAgoText = timeAgo(DateTime(
        postTime[0], postTime[1], postTime[2], postTime[3], postTime[4]));

    reactionsCount = widget.commentEmojisModel.length;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Directionality(
        textDirection: TextDirection.rtl,
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                                  imageUrl: widget.userImage,
                                                ),
                                              ))),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.username,
                                            style: AppTypography.kBold14
                                                .copyWith(
                                                color: AppColors.cTitle),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              timeAgoText,
                                              style: AppTypography.kLight12
                                                  .copyWith(
                                                  color: AppColors.cBlack),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                widget.comment,
                                style: AppTypography.kLight14
                                    .copyWith(color: AppColors.cBlack),
                              ),
                            ],
                          )),
                    ],
                  ),
                  widget.commentEmojisModel.isNotEmpty ? const Divider(
                    color: AppColors.grey,
                  ) : Container(),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.commentEmojisModel.isNotEmpty
                          ? Row(
                        children: [
                          Bounceable(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints.expand(
                                    height: MediaQuery.sizeOf(context)
                                        .height -
                                        widget.statusBarHeight -
                                        300.h,
                                    width: MediaQuery.sizeOf(context)
                                        .width),
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
                                    child:
                                    ReactionsCommentBottomSheet(
                                        statusBarHeight: widget
                                            .statusBarHeight,
                                        commentEmojiModel: widget
                                            .commentEmojisModel),
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width:
                              MediaQuery.sizeOf(context).width *
                                  0.5,
                              height: 30.h,
                              child: Stack(
                                children: widget.commentEmojisModel
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
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(reactionsCount.toString()),
                        ],
                      )
                          : Container(),
                    ],
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
      ),
    );
  }
}
