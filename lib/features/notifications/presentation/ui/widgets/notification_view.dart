import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../data/model/requests/update_notification_to_seeen_request.dart';
import '../../bloc/notifications_cubit.dart';
import '../../bloc/notifications_state.dart';

class NotificationView extends StatefulWidget {
  final String id;
  final String username;
  final String userImage;
  final String notification;
  final String time;
  final bool seen;
  final double statusBarHeight;
  const NotificationView({
    super.key,
    required this.id,
    required this.username,
    required this.userImage,
    required this.notification,
    required this.time,
    required this.seen,
    required this.statusBarHeight,
  });

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String timeAgoText = "";

  Future<void> updateNotificationToSeen(String notificationId) async {
    NotificationsCubit.get(context).updateNotificationToSeenUseCase(
        UpdateNotificationToSeenRequest(id: notificationId));
  }

  @override
  void initState() {
    List<int> postTime = splitDateTime(widget.time);
    timeAgoText = timeAgo(DateTime(
        postTime[0], postTime[1], postTime[2], postTime[3], postTime[4]));

    updateNotificationToSeen(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is UpdateNotificationToSeenLoadingState) {
          showLoading();
        } else if (state is UpdateNotificationToSeenSuccessState) {
          hideLoading();
        } else if (state is UpdateNotificationToSeenErrorState) {
          hideLoading();
          showSnackBar(context, state.errorNotification);
        } else if (state is NotificationsNoInternetState) {
          hideLoading();
          onError(context, AppStrings.noInternet);
        }
      },
      builder: (context, state) {
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
                              child: Bounceable(
                            onTap: () {},
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
                                                    placeholder: (context,
                                                            url) =>
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
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SvgPicture.asset(
                                          widget.seen
                                              ? AppAssets.seen
                                              : AppAssets.unseen,
                                          width: 25.w,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  widget.notification,
                                  style: AppTypography.kLight14
                                      .copyWith(color: AppColors.cBlack,fontFamily: "Cairo"),
                                ),
                              ],
                            ),
                          )),
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
      },
    );
  }
}
