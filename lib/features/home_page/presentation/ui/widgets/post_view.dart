import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_subscriber_request.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_bottom_sheet.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_view.dart';
import 'package:last/features/home_page/presentation/ui/widgets/update_post_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../data/model/comments_model.dart';
import '../../../data/model/emoji_model.dart';
import '../../../data/model/requests/add_emoji_request.dart';
import '../../../data/model/requests/add_subscriber_request.dart';
import '../../../data/model/subscribers_model.dart';
import '../../../domain/entities/emoji_entity.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';
import 'add_comment_bottom_sheet.dart';
import 'comments_bottom_sheet.dart';

class PostView extends StatefulWidget {
  final String id;
  final String postAlsha;
  final String postUsername;
  final String postUserImage;
  final String loggedInUserName;
  final String loggedInUserImage;
  final String time;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  final List<SubscribersModel> subscribersList;
  final double statusBarHeight;
  Function addNewComment;
  Function addNewEmoji;
  Function postUpdated;
  int index;
  PostView({
    super.key,
    required this.id,
    required this.postAlsha,
    required this.postUsername,
    required this.postUserImage,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.emojisList,
    required this.commentsList,
    required this.subscribersList,
    required this.statusBarHeight,
    required this.addNewComment,
    required this.addNewEmoji,
    required this.time,
    required this.index,
    required this.postUpdated,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
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
                create: (context) => sl<HomePageCubit>(),
                child: BlocConsumer<HomePageCubit, HomePageState>(
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
                              HomePageCubit.get(context).deletePost(widget.id);
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
                              Navigator.pop(context);
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
                                      child: UpdatePostBottomSheet(
                                        postModel: PostModel(
                                            id: widget.id,
                                            postAlsha: widget.postAlsha,
                                            username: widget.postUsername,
                                            userImage: widget.postUserImage,
                                            emojisList: widget.emojisList,
                                            commentsList: widget.commentsList,
                                            time: widget.time,
                                            subscribersList:
                                                widget.subscribersList),
                                        statusBarHeight: widget.statusBarHeight,
                                        postUpdated: () {
                                          widget.postUpdated();
                                        },
                                      ));
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
            Positioned(
                left: position.dx - MediaQuery.sizeOf(context).width * 0.75,
                top: position.dy - 40.h,
                child: BlocProvider(
                  create: (context) => sl<HomePageCubit>(),
                  child: BlocConsumer<HomePageCubit, HomePageState>(
                    listener: (context, state) async {
                      if (state is AddEmojiSuccessState) {
                        if (userReacted) {
                          widget.addNewEmoji(0);
                        } else {
                          widget.addNewEmoji(1);
                        }
                        _removePopup();
                      } else if (state is AddEmojiErrorState) {
                        showSnackBar(context, state.errorMessage);
                      } else if (state is DeleteEmojiSuccessState) {
                        widget.addNewEmoji(-1);
                        _removePopup();
                      } else if (state is DeleteEmojiErrorState) {
                        showSnackBar(context, state.errorMessage);
                      }
                    },
                    builder: (context, state) {
                      return ReactionsView(
                        returnEmojiData: (EmojiEntity returnedEmojiData) {
                          userReacted = widget.emojisList.where(
                                  (element) => element.username == widget.loggedInUserName).isNotEmpty;

                          AddEmojiRequest addEmojiRequest = AddEmojiRequest(
                              postId: widget.id,
                              emojiModel: EmojiModel(
                                  postId: widget.id,
                                  emojiData: returnedEmojiData.emojiData,
                                  username: widget.loggedInUserName,
                                  userImage: widget.loggedInUserImage));
                          HomePageCubit.get(context).addEmoji(addEmojiRequest);
                        },
                        deleteEmojiData: () {
                          int emojiIndex = widget.emojisList.indexWhere(
                              (element) => element.postId == widget.id);
                          DeleteEmojiRequest deleteEmojiRequest =
                              DeleteEmojiRequest(
                                  postId: widget.id,
                                  emojiId: widget.emojisList[emojiIndex].id!);
                          HomePageCubit.get(context)
                              .deleteEmoji(deleteEmojiRequest);
                        },
                      );
                    },
                  ),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomePageCubit>(),
      child: FadeInUp(
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
                                              errorWidget: (context, url, error) =>
                                                  Image.asset(AppAssets.profile),
                                              imageUrl: widget.postUserImage,
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
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.50,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget.postUsername,
                                                style: AppTypography.kBold14
                                                    .copyWith(
                                                        color:
                                                            AppColors.cTitle),
                                                overflow: TextOverflow.ellipsis,
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
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        widget.subscribersList
                                                .where((element) =>
                                                    element.username ==
                                                    widget.postUsername)
                                                .isNotEmpty
                                            ? AppAssets.notificationOn
                                            : AppAssets.notificationOff,
                                        width: 25.w,
                                      )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
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
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            widget.postAlsha,
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
                  Row(
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
                                              150.h,
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
                                      child: CommentsBottomSheet(
                                        userImage: widget.postUserImage,
                                        userName: widget.postUsername,
                                        postId: widget.id,
                                          addNewComment: (int status) {
                                            widget.addNewComment(status);
                                          },
                                          statusBarHeight:
                                              widget.statusBarHeight,
                                          commentsList: widget.commentsList),
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
                                    AppStrings.comments,
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
                                          child: ReactionsBottomSheet(
                                              statusBarHeight:
                                                  widget.statusBarHeight,
                                              emojisList: widget.emojisList),
                                        );
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.5,
                                    height: 30.h,
                                    child: Stack(
                                      children: widget.emojisList
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        return Positioned(
                                            left: index * reactPosition,
                                            child:
                                            CircleAvatar(
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
                                                        style: AppTypography
                                                            .kExtraLight18,
                                                      ),
                                                    ))));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(widget.emojisList.length.toString()),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  widget.commentsList.isNotEmpty || widget.emojisList.isNotEmpty
                      ? const Divider(
                          color: AppColors.grey,
                        )
                      : Container(),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          SizedBox(
                            width: 30.w,
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
                                      child: AddCommentBottomSheet(
                                          postId: widget.id,
                                          statusBarHeight:
                                              widget.statusBarHeight,
                                          username: widget.loggedInUserName,
                                          userImage: widget.loggedInUserImage,
                                          addNewComment: (int status) {
                                            widget.addNewComment(status);
                                          },
                                          id: widget.id));
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              AppAssets.comments,
                              width: 30.w,
                            ),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Bounceable(
                            onTap: () {
                              Share.share(
                                widget.postAlsha,
                                subject: AppStrings.appName,
                              );
                            },
                            child: SvgPicture.asset(
                              AppAssets.share,
                              width: 25.w,
                            ),
                          ),
                        ],
                      ),
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
