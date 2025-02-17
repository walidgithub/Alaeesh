import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../home_page/data/model/comments_model.dart';
import '../../../../home_page/data/model/emoji_model.dart';
import '../../../../home_page/data/model/post_subscribers_model.dart';
import '../../bloc/mine_cubit.dart';
import '../../bloc/mine_state.dart';
import 'mine_comments_bottom_sheet.dart';

class MinePostView extends StatefulWidget {
  final String id;
  final String postAlsha;
  final String postUsername;
  final String postUserImage;
  final String loggedInUserName;
  final String loggedInUserImage;
  final String time;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  final List<PostSubscribersModel> postSubscribersList;
  final double statusBarHeight;
  Function addNewEmoji;
  Function updateComment;
  int index;
  Function postUpdated;
  MinePostView({
    super.key,
    required this.id,
    required this.postAlsha,
    required this.postUsername,
    required this.postUserImage,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.emojisList,
    required this.commentsList,
    required this.postSubscribersList,
    required this.statusBarHeight,
    required this.time,
    required this.index,
    required this.addNewEmoji,
    required this.updateComment,
    required this.postUpdated,
  });

  @override
  State<MinePostView> createState() => _MinePostViewState();
}

class _MinePostViewState extends State<MinePostView> {
  double reactPosition = 20.0;
  String timeAgoText = "";
  

  bool userReacted = false;

  @override
  void initState() {
    List<int> postTime = splitDateTime(widget.time);
    timeAgoText = timeAgo(DateTime(
        postTime[0], postTime[1], postTime[2], postTime[3], postTime[4]));
    super.initState();
  }

  Future<void> _showPostPopupMenu(
      BuildContext context, Offset position, int index) async {
    await showMenu(
        context: context,
        color: AppColors.cWhite,
        menuPadding: EdgeInsets.zero,
        elevation: 4,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          position.dx + 1,
          position.dy + 1,
        ),
        items: [
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: BlocProvider(
                create: (context) => sl<MineCubit>(),
                child: BlocConsumer<MineCubit, MineState>(
                  listener: (context, state) async {
                    if (state is DeletePostLoadingState) {
                      showLoading();
                    } else if (state is DeletePostSuccessState) {
                      hideLoading();
                      widget.postUpdated();
                      Navigator.pop(context);
                    } else if (state is DeletePostErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                      Navigator.pop(context);
                    } else if (state is MineNoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cTitle),
                          borderRadius: BorderRadius.all(Radius.circular(5.r))),
                      child: Column(
                        children: [
                          Bounceable(
                            onTap: () {
                              MineCubit.get(context).deletePost(widget.id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.delete,
                                  width: 18.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  AppStrings.delete,
                                  style: AppTypography.kLight12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))
        ]);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                Image.asset(AppAssets.profile),
                                            imageUrl: widget.postUserImage,
                                          ),
                                        ))),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.50,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.postUsername,
                                              style: AppTypography.kBold14
                                                  .copyWith(
                                                      color: AppColors.cTitle),
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.ltr,
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
                                            .copyWith(color: AppColors.greyDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                widget.loggedInUserName == widget.postUsername
                                    ? SizedBox(
                                        width: 10.w,
                                      )
                                    : Container(),
                                widget.loggedInUserName == widget.postUsername
                                    ? GestureDetector(
                                        onTapDown: (TapDownDetails details) {
                                          _showPostPopupMenu(
                                              context,
                                              details.globalPosition,
                                              widget.index);
                                        },
                                        child: SvgPicture.asset(
                                          AppAssets.menu,
                                          width: 25.w,
                                        ))
                                    : Container()
                              ],
                            )
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
                        )
                      ],
                    )),
                  ],
                ),
                widget.commentsList.isNotEmpty || widget.emojisList.isNotEmpty
                    ? const Divider(
                        color: AppColors.grey,
                      )
                    : Container(),
                SizedBox(
                  height: widget.commentsList.isNotEmpty ||
                          widget.emojisList.isNotEmpty
                      ? 40.h
                      : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.commentsList.isNotEmpty
                          ? Bounceable(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints.expand(
                                      height:
                                          MediaQuery.sizeOf(context).height -
                                              widget.statusBarHeight -
                                              50.h,
                                      width: MediaQuery.sizeOf(context).width),
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
                                      child: MineCommentsBottomSheet(
                                        postAlsha: widget.postAlsha,
                                        userImage: widget.loggedInUserImage,
                                        userName: widget.loggedInUserName,
                                        postId: widget.id,
                                        statusBarHeight: widget.statusBarHeight,
                                        commentsList: widget.commentsList,
                                        updateComment: (int status) {
                                          widget.updateComment(status);
                                        },
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
                                BlocProvider(
                                  create: (context) => sl<MineCubit>(),
                                  child: BlocConsumer<MineCubit, MineState>(
                                    listener: (context, state) async {
                                      if (state is DeleteEmojiSuccessState) {
                                        showLoading();
                                      } else if (state
                                          is DeleteEmojiSuccessState) {
                                        hideLoading();
                                        widget.addNewEmoji(-1);
                                      } else if (state
                                          is DeleteEmojiErrorState) {
                                        hideLoading();
                                        showSnackBar(
                                            context, state.errorMessage);
                                      } else if (state is MineNoInternetState) {
                                        hideLoading();
                                        onError(context, AppStrings.noInternet);
                                      }
                                    },
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          DeleteEmojiRequest
                                              deleteEmojiRequest =
                                              DeleteEmojiRequest(
                                                  postId: widget.id,
                                                  emojiId:
                                                  widget.emojisList[0].id!);
                                          MineCubit.get(context)
                                              .deleteEmoji(deleteEmojiRequest);
                                        },
                                        child: Text(
                                          AppStrings.skip,
                                          style: AppTypography.kBold14
                                              .copyWith(
                                                  color: AppColors.cSecondary),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                  height: 30.h,
                                  child: Stack(
                                    children: widget.emojisList
                                        .asMap()
                                        .entries
                                        .toList()
                                        .fold<List<MapEntry<int, dynamic>>>([],
                                            (acc, entry) {
                                      if (!acc.any((e) =>
                                          e.value.emojiData ==
                                          entry.value.emojiData)) {
                                        acc.add(entry);
                                      }
                                      return acc;
                                    }).map((entry) {
                                      int index = entry.key; // Original index
                                      return Positioned(
                                        left: index * reactPosition,
                                        child: CircleAvatar(
                                          radius: 15.r,
                                          backgroundColor: AppColors.cWhite,
                                          child: Container(
                                            padding: EdgeInsets.all(1.w),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.cSecondary,
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Text(
                                                entry.value.emojiData,
                                                style:
                                                    AppTypography.kExtraLight18,
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
