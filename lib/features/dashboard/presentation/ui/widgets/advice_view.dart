import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/dashboard/data/model/requests/send_reply_request.dart';
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
import '../../bloc/dashboard_cubit.dart';
import '../../bloc/dashboard_state.dart';
import 'dashboard_comments_bottom_sheet.dart';

class AdviceView extends StatefulWidget {
  final String adviceId;
  final String adviceText;
  final String username;
  final String userImage;
  final String time;
  final double statusBarHeight;
  final int index;
  const AdviceView({
    super.key,
    required this.adviceId,
    required this.adviceText,
    required this.username,
    required this.userImage,
    required this.statusBarHeight,
    required this.time,
    required this.index,
  });

  @override
  State<AdviceView> createState() => _AdviceViewState();
}

class _AdviceViewState extends State<AdviceView> {
  String timeAgoText = "";
  final TextEditingController _replyUsController = TextEditingController();
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
                    if (state is DashboardNoInternetState) {
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
                              DashboardCubit.get(context)
                                  .deletePost(widget.adviceId);
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
        width: MediaQuery.sizeOf(context).width - 20.w,
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
                                            imageUrl: widget.userImage,
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
                                              widget.username,
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
                            Row(
                              children: [
                                GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      _showPostPopupMenu(context,
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
                        ReadMoreText(
                          widget.adviceText,
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
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.75,
                      child: TextField(
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          controller: _replyUsController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.w),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.cSecondary),
                                borderRadius:
                                    BorderRadius.circular(AppConstants.radius),
                              ),
                              labelText: AppStrings.reply,
                              border: InputBorder.none)),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    BlocProvider(
                      create: (context) => sl<DashboardCubit>(),
                      child: BlocConsumer<DashboardCubit, DashboardState>(
                          listener: (context, state) {
                        if (state is DashboardSendReplyLoadingState) {
                          showLoading();
                        } else if (state is DashboardSendReplySuccessState) {
                          hideLoading();
                          showSnackBar(context, AppStrings.addSuccess);
                          _replyUsController.text = "";
                        } else if (state is DashboardSendReplyErrorState) {
                          hideLoading();
                          showSnackBar(context, state.errorMessage);
                        } else if (state is DashboardNoInternetState) {
                          hideLoading();
                          onError(context, AppStrings.noInternet);
                        }
                      }, builder: (context, state) {
                        return Bounceable(
                            onTap: () {
                              if (_replyUsController.text.trim() == "") return;
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(now);
                              String formattedTime =
                                  DateFormat('hh:mm a').format(now);

                              SendReplyRequest sendReplyRequest =
                                  SendReplyRequest(
                                      seen: false,
                                      username: widget.username,
                                      time: '$formattedDate $formattedTime',
                                      message: _replyUsController.text.trim());
                              DashboardCubit.get(context)
                                  .sendReply(sendReplyRequest);
                            },
                            child: SvgPicture.asset(
                              AppAssets.send,
                              width: 30.w,
                            ));
                      }),
                    )
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
