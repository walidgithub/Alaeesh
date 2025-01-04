import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/home_page/data/model/comments_model.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_emoji_request.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_comment_bottom_sheet.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
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
import '../../../data/model/comment_emoji_model.dart';
import '../../../data/model/requests/delete_comment_request.dart';
import '../../../domain/entities/emoji_entity.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';
import 'update_comment_bottom_sheet.dart';
import 'reactions_view.dart';

class CommentView extends StatefulWidget {
  final String id;
  final String comment;
  final String username;
  final String userImage;
  final String time;
  final String postId;
  final List<CommentEmojiModel> commentEmojisModel;
  double statusBarHeight;
  Function addNewCommentEmoji;
  Function updateComment;
  final String loggedInUserName;
  final String loggedInUserImage;
  int index;
  CommentView({
    super.key,
    required this.id,
    required this.comment,
    required this.username,
    required this.userImage,
    required this.time,
    required this.commentEmojisModel,
    required this.statusBarHeight,
    required this.postId,
    required this.addNewCommentEmoji,
    required this.index,
    required this.updateComment,
    required this.loggedInUserName,
    required this.loggedInUserImage,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
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

  void _showPopup(BuildContext context, Offset position) {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removePopup,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: _removePopup,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            BlocProvider(
                create: (context) => sl<HomePageCubit>(),
                child: BlocConsumer<HomePageCubit, HomePageState>(
                  listener: (context, state) {
                    if (state is DeleteCommentEmojiSuccessState) {
                      widget.updateComment(-1);
                      _removePopup();
                    } else if (state is DeleteCommentEmojiErrorState) {
                      showSnackBar(context, state.errorMessage);
                      _removePopup();
                    }
                  },
                  builder: (context, state) {
                    return Positioned(
                        left: position.dx -
                            MediaQuery.sizeOf(context).width * 0.75,
                        top: position.dy - 40.h,
                        child: ReactionsView(
                          returnEmojiData: (EmojiEntity returnedEmojiData) {
                            _removePopup();
                            widget.addNewCommentEmoji(returnedEmojiData);
                          },
                          deleteEmojiData: () {
                            int emojiIndex = widget.commentEmojisModel.indexWhere((element) => element.commentId == widget.id && element.username == widget.loggedInUserName);
                            if (emojiIndex < 0) {
                              widget.updateComment(0);
                              _removePopup();
                              return;
                            }
                            DeleteCommentEmojiRequest
                                deleteCommentEmojiRequest =
                                DeleteCommentEmojiRequest(
                                    postId: widget.postId,
                                    emojiId: widget.commentEmojisModel[emojiIndex].id!,
                                    commentId: widget.id);
                            HomePageCubit.get(context)
                                .deleteCommentEmoji(deleteCommentEmojiRequest);
                          },
                        ));
                  },
                ))
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

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
                create: (context) => sl<HomePageCubit>(),
                child: BlocConsumer<HomePageCubit, HomePageState>(
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
                              HomePageCubit.get(context)
                                  .deleteComment(deleteCommentRequest);
                            },
                            child: SizedBox(
                              width: 90.w,
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
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Bounceable(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints.expand(
                                    height: MediaQuery.sizeOf(context).height -
                                        widget.statusBarHeight -
                                        100.h,
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
                                      child: UpdateCommentBottomSheet(
                                          statusBarHeight:
                                              widget.statusBarHeight,
                                          updateComment: (int status) {
                                            widget.updateComment(status);
                                            Navigator.pop(context);
                                          },
                                          commentModel: CommentsModel(
                                              id: widget.id,
                                              postId: widget.postId,
                                              username: widget.loggedInUserName,
                                              userImage: widget.loggedInUserImage,
                                              time: widget.time,
                                              comment: widget.comment,
                                              commentEmojiModel:
                                                  widget.commentEmojisModel)));
                                },
                              );
                            },
                            child: SizedBox(
                              width: 90.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.edit,
                                    width: 15.w,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    AppStrings.edit,
                                    style: AppTypography.kLight13,
                                  ),
                                ],
                              ),
                            ),
                          )
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
                                              errorWidget: (context, url, error) =>
                                                  Image.asset(AppAssets.profile),
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
                                            .copyWith(color: AppColors.cTitle),
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
                                      onTap: () {

                                      },
                                      child: SvgPicture.asset(
                                        AppAssets.notificationOff,
                                        width: 25.w,
                                      )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                      onTapDown: (TapDownDetails details) {
                                        _showCommentPopupMenu(context,
                                            details.globalPosition, widget.index);
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
                  const Divider(
                    color: AppColors.grey,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          if (_overlayEntry == null) {
                            _showPopup(context, details.globalPosition);
                          } else {
                            _removePopup();
                          }
                        },
                        child: SvgPicture.asset(
                          AppAssets.emoji,
                          width: 25.w,
                        ),
                      ),
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
                                          child: ReactionsCommentBottomSheet(
                                              statusBarHeight:
                                                  widget.statusBarHeight,
                                              commentEmojiModel:
                                                  widget.commentEmojisModel),
                                        );
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.5,
                                    height: 30.h,
                                    child: Stack(
                                      children: widget.commentEmojisModel
                                          .asMap()
                                          .entries
                                          .toList()
                                          .fold<List<MapEntry<int, dynamic>>>([], (acc, entry) {
                                        if (!acc.any((e) => e.value.emojiData == entry.value.emojiData)) {
                                          acc.add(entry);
                                        }
                                        return acc;
                                      })
                                          .map((entry) {
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
                                                  style: AppTypography.kExtraLight18,
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

// bool isUserReacted = widget.emojisList.where((element) => element.username == widget.username).isNotEmpty;
// if (isUserReacted) {
//   widget.emojisList.removeWhere((element) => element.username == widget.username);
//   widget.emojisList.add(EmojiModel(
//       id: returnedEmojiData.id,
//       postId: widget.id,
//       username: widget.username,
//       userImage: widget.userImage,
//       emojiData: returnedEmojiData.emojiData));
// } else {
//   widget.emojisList.add(EmojiModel(
//       id: returnedEmojiData.id,
//       postId: widget.id,
//       username: widget.username,
//       userImage: widget.userImage,
//       emojiData: returnedEmojiData.emojiData));
//   reactionsCount++;
// }
