import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/core/utils/constant/app_strings.dart';
import 'package:last/features/messages/data/model/requests/update_message_to_seeen_request.dart';
import '../../../../../core/functions/time_ago_function.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/card_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../bloc/messages_cubit.dart';
import '../../bloc/messages_state.dart';

class MessageView extends StatefulWidget {
  final String id;
  final String username;
  final String role;
  final String message;
  final String time;
  final bool seen;
  final double statusBarHeight;
  const MessageView({
    super.key,
    required this.id,
    required this.role,
    required this.username,
    required this.message,
    required this.time,
    required this.seen,
    required this.statusBarHeight,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  String timeAgoText = "";
  

  Future<void> updateMessageToSeen(String messageId) async {
    MessagesCubit.get(context).updateMessageToSeenUseCase(UpdateMessageToSeenRequest(id: messageId));
  }

  @override
  void initState() {
    List<int> postTime = splitDateTime(widget.time);
    timeAgoText = timeAgo(DateTime(
        postTime[0], postTime[1], postTime[2], postTime[3], postTime[4]));

    updateMessageToSeen(widget.id);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesCubit, MessagesState>(
      listener: (context, state) {
        if (state is UpdateMessageToSeenLoadingState) {
          showLoading();
        } else if (state is UpdateMessageToSeenSuccessState) {
          hideLoading();
        } else if (state is UpdateMessageToSeenErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        } else if (state is MessagesNoInternetState) {
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.role == "admin" ? AppStrings.regarding : AppStrings.messageFromAdmin,
                                                style: AppTypography.kBold14
                                                    .copyWith(color: AppColors.cTitle),
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
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          SvgPicture.asset(
                                            widget.seen ? AppAssets.seen : AppAssets.unseen,
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
                                    widget.message,
                                    style: AppTypography.kLight14
                                        .copyWith(color: AppColors.cBlack,fontFamily: "Cairo"),
                                  ),
                                ],
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
