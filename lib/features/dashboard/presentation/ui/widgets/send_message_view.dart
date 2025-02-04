import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/style/app_colors.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../data/model/requests/send_reply_request.dart';
import '../../bloc/dashboard_cubit.dart';
import 'dart:ui' as ui;

import '../../bloc/dashboard_state.dart';

class SendMessageDialog extends StatefulWidget {
  String username;
  SendMessageDialog({super.key, required this.username});

  static Future<void> show(BuildContext context, String username) async {
    final navigator = Navigator.of(context);
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => SendMessageDialog(username: username),
    );

    if (navigator.mounted) {
      FocusScope.of(navigator.context).requestFocus(FocusNode());
    }
  }

  static void hide(BuildContext context) => Navigator.of(context).pop();

  @override
  State<SendMessageDialog> createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  TextEditingController messageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: AppColors.cWhite,
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomDivider(),
              SizedBox(height: 20.h),
              Text(AppStrings.sendMessage, style: AppTypography.kBold24),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 50.w,
                      child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          controller: messageEditingController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.cTitle),
                                borderRadius: BorderRadius.circular(AppConstants.radius),
                              ),
                              hintText: AppStrings.message,
                              labelText: AppStrings.message,
                              border: InputBorder.none)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 31.h),
              Row(
                children: [
                  BlocProvider(
                    create: (context) => sl<DashboardCubit>(),
                    child: BlocConsumer<DashboardCubit, DashboardState>(
                        listener: (context, state) {
                          if (state is DashboardSendReplyLoadingState) {
                            showLoading();
                          } else if (state is DashboardSendReplySuccessState) {
                            hideLoading();
                            showSnackBar(context, AppStrings.addSuccess);
                            SendMessageDialog.hide(context);
                          } else if (state is DashboardSendReplyErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                          } else if (state is DashboardNoInternetState) {
                            hideLoading();
                            onError(context, AppStrings.noInternet);
                          }
                        }, builder: (context, state) {
                      return PrimaryButton(
                        onTap: () {
                          if (messageEditingController.text.trim() == "") return;
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
                              message: messageEditingController.text.trim());
                          DashboardCubit.get(context)
                              .sendReply(sendReplyRequest);
                        },
                        text: AppStrings.send,
                        width: 160.w,
                        gradient: true,
                      );
                    }),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    onTap: () {
                      SendMessageDialog.hide(context);
                    },
                    text: AppStrings.closeDialog,
                    width: 120.w,
                    gradient: false,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}