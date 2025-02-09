import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/dashboard/presentation/ui/widgets/send_message_dialog.dart';
import 'package:last/features/home_page/presentation/ui/widgets/reactions_bottom_sheet.dart';
import 'package:last/features/welcome/data/model/user_permissions_model.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
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
import 'dart:ui' as ui;
import '../../../../home_page/data/model/comments_model.dart';
import '../../../../home_page/data/model/emoji_model.dart';
import '../../../../welcome/presentation/bloc/welcome_state.dart';
import '../../../data/model/requests/send_reply_request.dart';
import '../../bloc/dashboard_cubit.dart';
import '../../bloc/dashboard_state.dart';
import 'dashboard_comments_bottom_sheet.dart';

class DashboardPostView extends StatefulWidget {
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
  Function addNewComment;
  Function postUpdated;
  int index;
  DashboardPostView({
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
    required this.addNewComment,
    required this.time,
    required this.index,
    required this.postUpdated,
  });

  @override
  State<DashboardPostView> createState() => _DashboardPostViewState();
}

class _DashboardPostViewState extends State<DashboardPostView> {
  double reactPosition = 20.0;
  String timeAgoText = "";
  bool userReacted = false;
  bool isEnabled = true;
  bool isUser = true;
  String role = "";
  TapDownDetails postPopupMenuDetails = TapDownDetails();

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
                create: (context) => sl<DashboardCubit>(),
                child: BlocConsumer<DashboardCubit, DashboardState>(
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
                    } else if (state is DashboardNoInternetState) {
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
                              DashboardCubit.get(context).deletePost(widget.id);
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
                            create: (homeContext) => sl<WelcomeCubit>(),
                            child: BlocConsumer<WelcomeCubit, WelcomeState>(
                              listener: (context, state) async {
                                if (state
                                    is UpdateUserPermissionsLoadingState) {
                                  showLoading();
                                } else if (state
                                    is UpdateUserPermissionsSuccessState) {
                                  hideLoading();
                                  DateTime now = DateTime.now();
                                  String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(now);
                                  String formattedTime =
                                  DateFormat('hh:mm a').format(now);

                                  SendReplyRequest sendReplyRequest =
                                  SendReplyRequest(
                                      seen: false,
                                      username: widget.postUsername,
                                      time: '$formattedDate $formattedTime',
                                      message: isEnabled ? AppStrings.preventMessage : AppStrings.addMessage);
                                  WelcomeCubit.get(context)
                                      .sendReply(sendReplyRequest);
                                } else if (state
                                    is UpdateUserPermissionsErrorState) {
                                  showSnackBar(context, state.errorMessage);
                                  hideLoading();
                                } else if (state is SendReplyLoadingState) {
                                  showLoading();
                                } else if (state is SendReplySuccessState) {
                                  hideLoading();
                                  Navigator.pop(context);
                                } else if (state is SendReplyErrorState) {
                                  hideLoading();
                                  showSnackBar(context, state.errorMessage);
                                } else if (state is WelcomeNoInternetState) {
                                  hideLoading();
                                  onError(context, AppStrings.noInternet);
                                }
                              },
                              builder: (context, state) {
                                return Bounceable(
                                  onTap: () {
                                    if (isEnabled) {
                                      UserPermissionsModel
                                          userPermissionsModel =
                                          UserPermissionsModel(
                                              role: role,
                                              username: widget.postUsername,
                                              enableAdd: "no");
                                      WelcomeCubit.get(context)
                                          .updateUserPermissions(
                                              userPermissionsModel);
                                    } else {
                                      UserPermissionsModel
                                          userPermissionsModel =
                                          UserPermissionsModel(
                                              role: role,
                                              username: widget.postUsername,
                                              enableAdd: "yes");
                                      WelcomeCubit.get(context)
                                          .updateUserPermissions(
                                              userPermissionsModel);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        isEnabled
                                            ? AppAssets.preventAdd
                                            : AppAssets.enableAdd,
                                        width: 20.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        isEnabled
                                            ? AppStrings.preventAdd
                                            : AppStrings.enableAdd,
                                        style: AppTypography.kLight13,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          BlocProvider(
                            create: (homeContext) => sl<WelcomeCubit>(),
                            child: BlocConsumer<WelcomeCubit, WelcomeState>(
                              listener: (context, state) async {
                                if (state
                                    is UpdateUserPermissionsLoadingState) {
                                  showLoading();
                                } else if (state
                                    is UpdateUserPermissionsSuccessState) {
                                  hideLoading();
                                  Navigator.pop(context);
                                } else if (state
                                    is UpdateUserPermissionsErrorState) {
                                  showSnackBar(context, state.errorMessage);
                                  hideLoading();
                                } else if (state is WelcomeNoInternetState) {
                                  hideLoading();
                                  onError(context, AppStrings.noInternet);
                                }
                              },
                              builder: (context, state) {
                                return Bounceable(
                                  onTap: () {
                                    if (isUser) {
                                      UserPermissionsModel
                                          userPermissionsModel =
                                          UserPermissionsModel(
                                              role: "admin",
                                              username: widget.postUsername,
                                              enableAdd:
                                                  isEnabled ? "yes" : "no");
                                      WelcomeCubit.get(context)
                                          .updateUserPermissions(
                                              userPermissionsModel);
                                    } else {
                                      UserPermissionsModel
                                          userPermissionsModel =
                                          UserPermissionsModel(
                                              role: "user",
                                              username: widget.postUsername,
                                              enableAdd:
                                                  isEnabled ? "yes" : "no");
                                      WelcomeCubit.get(context)
                                          .updateUserPermissions(
                                              userPermissionsModel);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        isUser
                                            ? AppAssets.admin
                                            : AppAssets.profileIcon,
                                        width: 20.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        isUser
                                            ? AppStrings.admin
                                            : AppStrings.user,
                                        style: AppTypography.kLight13,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          isUser
                              ? Container()
                              : SizedBox(
                                  height: 10.h,
                                ),
                          isUser
                              ? Container()
                              : Bounceable(
                                  onTap: () {
                                    Navigator.pop(context);
                                    SendMessageDialog.show(
                                        context, widget.postUsername);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.send,
                                        width: 20.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        AppStrings.sendMessage,
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
                                            .copyWith(color: AppColors.cBlack),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            BlocProvider(
                              create: (homeContext) => sl<WelcomeCubit>(),
                              child: BlocConsumer<WelcomeCubit, WelcomeState>(
                                listener: (context, state) async {
                                  if (state is GetUserPermissionsLoadingState) {
                                    showLoading();
                                  } else if (state
                                      is GetUserPermissionsSuccessState) {
                                    hideLoading();
                                    role = state.userPermissionsModel.role;
                                    if (state.userPermissionsModel.enableAdd ==
                                        "yes") {
                                      setState(() {
                                        isEnabled = true;
                                      });
                                    } else if (state
                                            .userPermissionsModel.enableAdd ==
                                        "no") {
                                      setState(() {
                                        isEnabled = false;
                                      });
                                    }
                                    if (state.userPermissionsModel.role ==
                                        "admin") {
                                      setState(() {
                                        isUser = false;
                                      });
                                    } else if (state
                                            .userPermissionsModel.role ==
                                        "user") {
                                      setState(() {
                                        isUser = true;
                                      });
                                    }
                                    _showPostPopupMenu(
                                        context,
                                        postPopupMenuDetails.globalPosition,
                                        widget.index);
                                  } else if (state
                                      is GetUserPermissionsErrorState) {
                                    showSnackBar(context, state.errorMessage);
                                    hideLoading();
                                  } else if (state is WelcomeNoInternetState) {
                                    hideLoading();
                                    onError(context, AppStrings.noInternet);
                                  }
                                },
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                          onTapDown: (TapDownDetails details) {
                                            WelcomeCubit.get(context)
                                                .getUserPermissions(
                                                    widget.postUsername);
                                            setState(() {
                                              postPopupMenuDetails = details;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            AppAssets.menu,
                                            width: 25.w,
                                          ))
                                    ],
                                  );
                                },
                              ),
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
                                      textDirection: ui.TextDirection.rtl,
                                      child: DashboardCommentsBottomSheet(
                                        postAlsha: widget.postAlsha,
                                        userImage: widget.loggedInUserImage,
                                        userName: widget.loggedInUserName,
                                        postId: widget.id,
                                        addNewComment: (int status) {
                                          widget.addNewComment(status);
                                        },
                                        statusBarHeight: widget.statusBarHeight,
                                        commentsList: widget.commentsList,
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
