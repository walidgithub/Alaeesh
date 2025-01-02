import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';

class NotificationView extends StatefulWidget {
  final String id;
  final String postAlsha;
  final String username;
  final String userImage;
  final String time;
  final double statusBarHeight;
  const NotificationView(
      {super.key,
      required this.id,
      required this.postAlsha,
      required this.username,
      required this.userImage,
      required this.statusBarHeight,
      required this.time});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool showReactionsBox = false;
  double reactPosition = 20.0;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Bounceable(
        onTap: () {},
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
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Row(
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.username,
                                          style: AppTypography.kBold16
                                              .copyWith(color: AppColors.cTitle),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            widget.time,
                                            style: AppTypography.kLight12
                                                .copyWith(color: AppColors.cBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Bounceable(
                                    onTap: () {},
                                    child: SvgPicture.asset(AppAssets.delete,width: 20.w,))
                              ],
                            ),
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
                  SizedBox(
                    height: 10.h,
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
