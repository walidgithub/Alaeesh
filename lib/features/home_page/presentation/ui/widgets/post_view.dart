import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_bottom_sheet.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_view.dart';
import 'package:last/features/home_page/presentation/ui/widgets/report_complaint_dialog.dart';
import 'package:last/features/home_page/presentation/ui/widgets/update_post_bottom_sheet.dart';
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
import '../../../../welcome/presentation/bloc/welcome_cubit.dart';
import '../../../../welcome/presentation/bloc/welcome_state.dart';
import '../../../data/model/comments_model.dart';
import '../../../data/model/emoji_model.dart';
import '../../../data/model/requests/add_emoji_request.dart';
import '../../../data/model/post_subscribers_model.dart';
import 'dart:ui' as ui;
import '../../../domain/entities/emoji_entity.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';
import 'add_comment_view.dart';
import 'comments_bottom_sheet.dart';

class PostView extends StatefulWidget {
  final String id;
  final String postAlsha;
  final String postUsername;
  final String postUserImage;
  final String postUserEmail;
  final String loggedInUserName;
  final String loggedInUserImage;
  final String loggedInUserEmail;
  final String time;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  final List<PostSubscribersModel> postSubscribersList;
  final bool userSubscribed;
  final double statusBarHeight;
  Function addNewComment;
  Function addNewEmoji;
  Function postUpdated;
  Function addOrRemoveSubscriber;
  Function getUserPosts;
  int index;
  PostView({
    super.key,
    required this.id,
    required this.postAlsha,
    required this.postUsername,
    required this.postUserImage,
    required this.postUserEmail,
    required this.loggedInUserName,
    required this.loggedInUserImage,
    required this.loggedInUserEmail,
    required this.emojisList,
    required this.commentsList,
    required this.postSubscribersList,
    required this.statusBarHeight,
    required this.addNewComment,
    required this.addNewEmoji,
    required this.time,
    required this.index,
    required this.postUpdated,
    required this.userSubscribed,
    required this.getUserPosts,
    required this.addOrRemoveSubscriber,
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
                      _removePopup();
                      showSnackBar(context, state.errorMessage);
                      Navigator.pop(context);
                    } else if (state is HomePageNoInternetState) {
                      hideLoading();
                      _removePopup();
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
                              HomePageCubit.get(context).deletePost(widget.id);
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
                                  style: AppTypography.kLight13,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          BlocProvider(
                            create: (context) => sl<WelcomeCubit>()
                              ..getUserPermissions(widget.loggedInUserName),
                            child: BlocBuilder<WelcomeCubit, WelcomeState>(
                              builder: (context, state) {
                                if (state is GetUserPermissionsLoadingState) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: AppColors.cTitle,
                                  ));
                                } else if (state
                                    is GetUserPermissionsSuccessState) {
                                  if (state.userPermissionsModel.enableAdd ==
                                      "yes") {
                                    return Bounceable(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          constraints: BoxConstraints.expand(
                                              height: MediaQuery.sizeOf(context)
                                                      .height -
                                                  widget.statusBarHeight -
                                                  100.h,
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
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: UpdatePostBottomSheet(
                                                  postModel: PostModel(
                                                      id: widget.id,
                                                      postAlsha:
                                                          widget.postAlsha,
                                                      username:
                                                          widget.postUsername,
                                                      userImage:
                                                          widget.postUserImage,
                                                      emojisList:
                                                          widget.emojisList,
                                                      commentsList:
                                                          widget.commentsList,
                                                      lastUpdateTime:
                                                          widget.time,
                                                      userEmail: widget.postUserEmail,
                                                      postSubscribersList: widget
                                                          .postSubscribersList),
                                                  statusBarHeight:
                                                      widget.statusBarHeight,
                                                  postUpdated: () {
                                                    widget.postUpdated();
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                          },
                                        );
                                      },
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
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                } else if (state
                                        is GetUserPermissionsErrorState ||
                                    state is WelcomeNoInternetState) {
                                  return SizedBox.shrink();
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          // Bounceable(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //
                          //   },
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       SvgPicture.asset(
                          //         AppAssets.edit,
                          //         width: 15.w,
                          //       ),
                          //       SizedBox(
                          //         width: 10.w,
                          //       ),
                          //       Text(
                          //         AppStrings.edit,
                          //         style: AppTypography.kLight13,
                          //       ),
                          //     ],
                          //   ),
                          // )
                          SizedBox(
                            height: 10.h,
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.pop(context);
                              ReportComplaintDialog.show(
                                  context, AppStrings.adminName, widget.id,"", AppStrings.alsha);
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.flag,
                                  width: 20.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  '${AppStrings.reportComplaint}${AppStrings.alsha} 🚨',
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
                top: position.dy - 90.h,
                child: BlocProvider(
                  create: (context) => sl<HomePageCubit>(),
                  child: BlocConsumer<HomePageCubit, HomePageState>(
                    listener: (context, state) async {
                      if (state is AddEmojiLoadingState) {
                        showLoading();
                      } else if (state is AddEmojiSuccessState) {
                        hideLoading();
                        if (userReacted) {
                          widget.addNewEmoji(0);
                        } else {
                          widget.addNewEmoji(1);
                        }
                        _removePopup();
                      } else if (state is AddEmojiErrorState) {
                        hideLoading();
                        _removePopup();
                        showSnackBar(context, state.errorMessage);
                      } else if (state is DeleteEmojiLoadingState) {
                        showLoading();
                      } else if (state is DeleteEmojiSuccessState) {
                        hideLoading();
                        widget.addNewEmoji(-1);
                        _removePopup();
                      } else if (state is DeleteEmojiErrorState) {
                        hideLoading();
                        _removePopup();
                        showSnackBar(context, state.errorMessage);
                      } else if (state is HomePageNoInternetState) {
                        hideLoading();
                        _removePopup();
                        onError(context, AppStrings.noInternet);
                      }
                    },
                    builder: (context, state) {
                      return ReactionsView(
                        returnEmojiData: (EmojiEntity returnedEmojiData) {
                          userReacted = widget.emojisList
                              .where((element) =>
                                  element.username == widget.loggedInUserName)
                              .isNotEmpty;

                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
                          String formattedTime =
                              DateFormat('hh:mm a').format(now);

                          AddEmojiRequest addEmojiRequest = AddEmojiRequest(
                              postId: widget.id,
                              emojiModel: EmojiModel(
                                  postId: widget.id,
                                  emojiData: returnedEmojiData.emojiData,
                                  username: widget.loggedInUserName,
                                  userEmail: widget.loggedInUserEmail,
                                  userImage: widget.loggedInUserImage),
                              lastTimeUpdate: '$formattedDate $formattedTime');
                          HomePageCubit.get(context).addEmoji(addEmojiRequest);
                        },
                        deleteEmojiData: () {
                          int emojiIndex = widget.emojisList.indexWhere(
                              (element) =>
                                  element.postId == widget.id &&
                                  element.username == widget.loggedInUserName);
                          if (emojiIndex < 0) {
                            widget.addNewEmoji(0);
                            _removePopup();
                            return;
                          }
                          DeleteEmojiRequest deleteEmojiRequest =
                              DeleteEmojiRequest(
                                  postId: widget.id,
                                  emojiId: widget.emojisList[emojiIndex].id!);
                          HomePageCubit.get(context)
                              .deleteEmoji(deleteEmojiRequest);
                        },
                        showSkip: widget.emojisList
                            .where((element) =>
                        element.username == widget.loggedInUserName)
                            .isNotEmpty,
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
                            Bounceable(
                              onTap: () {
                                widget.getUserPosts(widget.postUsername);
                              },
                              child: Row(
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                          AppAssets.profile),
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
                                                    ui.TextDirection.ltr,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Directionality(
                                        textDirection: ui.TextDirection.ltr,
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
                            ),
                            Row(
                              children: [
                                widget.loggedInUserName != widget.postUsername
                                    ? GestureDetector(
                                        onTap: () {
                                          if (widget.userSubscribed) {
                                            widget.addOrRemoveSubscriber(-1);
                                          } else {
                                            widget.addOrRemoveSubscriber(1);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          widget.userSubscribed
                                              ? AppAssets.notificationOn
                                              : AppAssets.notificationOff,
                                          width: 25.w,
                                        ))
                                    : Container(),
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
                          style: AppTypography.kLight14,
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
                const Divider(
                  color: AppColors.grey,
                ),
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
                                      textDirection: ui.TextDirection.rtl,
                                      child: CommentsBottomSheet(
                                        addOrRemoveSubscriber: (int status) {
                                          widget.addOrRemoveSubscriber(status);
                                        },
                                        postAlsha: widget.postAlsha,
                                        userImage: widget.loggedInUserImage,
                                        userName: widget.loggedInUserName,
                                        userEmail: widget.loggedInUserEmail,
                                        postId: widget.id,
                                        addNewComment: (int status, String id) {
                                          widget.addNewComment(status, id);
                                        },
                                        statusBarHeight: widget.statusBarHeight,
                                        commentsList: widget.commentsList,
                                        getUserPosts: (String userName) {
                                          widget.getUserPosts(userName);
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
                                    widget.commentsList.length > 1 &&
                                            widget.commentsList.length < 11
                                        ? AppStrings.comments
                                        : AppStrings.comment,
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
                                          textDirection: ui.TextDirection.rtl,
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
                                        MediaQuery.sizeOf(context).width * 0.55,
                                    height: 30.h,
                                    child: Stack(
                                      children: [
                                        ...widget.emojisList
                                            .asMap()
                                            .entries
                                            .toList()
                                            .fold<List<MapEntry<int, dynamic>>>(
                                                [], (acc, entry) {
                                              if (!acc.any((e) =>
                                                  e.value.emojiData ==
                                                  entry.value.emojiData)) {
                                                acc.add(entry);
                                              }
                                              return acc;
                                            })
                                            .take(4)
                                            .map((entry) {
                                              int index = entry.key;
                                              return Positioned(
                                                left: index * reactPosition,
                                                child: CircleAvatar(
                                                  radius: 15.r,
                                                  backgroundColor:
                                                      AppColors.cWhite,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(1.w),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .cSecondary,
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
                                            }),
                                        if (widget.emojisList.length > 3)
                                          Positioned(
                                            top: 5.h,
                                            left: 4.7 * reactPosition,
                                            child: Text(
                                              AppStrings.others,
                                              style: AppTypography.kBold18
                                                  .copyWith(
                                                      color:
                                                          AppColors.cSecondary,
                                                      fontSize: 15.sp),
                                            ),
                                          ),
                                      ],
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
                        BlocProvider(
                          create: (context) => sl<WelcomeCubit>(),
                          child: BlocConsumer<WelcomeCubit, WelcomeState>(
                              listener: (context, state) {
                            if (state is GetUserPermissionsLoadingState) {
                              showLoading();
                            } else if (state
                                is GetUserPermissionsSuccessState) {
                              hideLoading();
                              if (state.userPermissionsModel.enableAdd ==
                                  "yes") {
                                showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints.expand(
                                      height:
                                          MediaQuery.sizeOf(context).height -
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
                                        textDirection: ui.TextDirection.rtl,
                                        child: AddCommentBottomSheet(
                                            postId: widget.id,
                                            statusBarHeight:
                                                widget.statusBarHeight,
                                            username: widget.loggedInUserName,
                                            userImage: widget.loggedInUserImage,
                                            userEmail: widget.loggedInUserEmail,
                                            addNewComment:
                                                (int status, String id) {
                                              widget.addNewComment(status, id);
                                            },
                                            id: widget.id));
                                  },
                                );
                              } else {
                                onError(context, AppStrings.preventMessage);
                              }
                            } else if (state is GetUserPermissionsErrorState) {
                              hideLoading();
                            } else if (state is WelcomeNoInternetState) {
                              hideLoading();
                              onError(context, AppStrings.noInternet);
                            }
                          }, builder: (context, state) {
                            return Bounceable(
                              onTap: () {
                                WelcomeCubit.get(context).getUserPermissions(
                                    widget.loggedInUserName);
                              },
                              child: SvgPicture.asset(
                                AppAssets.comments,
                                width: 30.w,
                              ),
                            );
                          }),
                        ),
                        // SizedBox(
                        //   width: 30.w,
                        // ),
                        // Bounceable(
                        //   onTap: () {
                        //     Share.share(
                        //       widget.postAlsha,
                        //       subject: AppStrings.appName,
                        //     );
                        //   },
                        //   child: SvgPicture.asset(
                        //     AppAssets.share,
                        //     width: 25.w,
                        //   ),
                        // ),
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
    );
  }
}
