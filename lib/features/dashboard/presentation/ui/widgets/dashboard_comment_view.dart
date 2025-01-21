import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_comment_bottom_sheet.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../home_page/data/model/comment_emoji_model.dart';
import '../../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../bloc/dashboard_cubit.dart';
import '../../bloc/dashboard_state.dart';

class DashboardCommentView extends StatefulWidget {
  final String id;
  final String comment;
  final String username;
  final String userImage;
  final String time;
  final String postId;
  final List<CommentEmojiModel> commentEmojisModel;
  double statusBarHeight;
  Function updateComment;
  final String loggedInUserName;
  final String loggedInUserImage;
  int index;
  DashboardCommentView({
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
    required this.updateComment,
    required this.loggedInUserName,
    required this.loggedInUserImage,
  });

  @override
  State<DashboardCommentView> createState() => _DashboardCommentViewState();
}

class _DashboardCommentViewState extends State<DashboardCommentView> {
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

  OverlayEntry? _overlayEntry;

  Future<void> _showCommentPopupMenu(
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
                create: (context) => sl<DashboardCubit>(),
                child: BlocConsumer<DashboardCubit, DashboardState>(
                  listener: (context, state) async {
                    if (state is DeleteCommentLoadingState) {
                      showLoading();
                    } else if (state is DeleteCommentSuccessState) {
                      hideLoading();
                      widget.updateComment(-1);
                      Navigator.pop(context);
                    } else if (state is DeleteCommentErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                      Navigator.pop(context);
                    } else if (state is NoInternetState) {
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
                              DeleteCommentRequest deleteCommentRequest =
                              DeleteCommentRequest(
                                  postId: widget.postId,
                                  commentId: widget.id);
                              DashboardCubit.get(context)
                                  .deleteComment(deleteCommentRequest);
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.delete,
                                  width: 15.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  AppStrings.delete,
                                  style: AppTypography.kLight13,
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
                                  Row(
                                    children: [
                                     GestureDetector(
                                          onTapDown:
                                              (TapDownDetails details) {
                                            _showCommentPopupMenu(
                                                context,
                                                details.globalPosition,
                                                widget.index);
                                          },
                                          child: SvgPicture.asset(
                                            AppAssets.menu,
                                            width: 25.w,
                                          ))

                                    ],
                                  )
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
