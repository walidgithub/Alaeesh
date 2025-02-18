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
import '../../../data/model/user_model.dart';
import '../../bloc/dashboard_cubit.dart';
import 'dart:ui' as ui;

import '../../bloc/dashboard_state.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final navigator = Navigator.of(context);
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => AddUserDialog(),
    );

    if (navigator.mounted) {
      FocusScope.of(navigator.context).requestFocus(FocusNode());
    }
  }

  static void hide(BuildContext context) => Navigator.of(context).pop();

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController userEditingController = TextEditingController();

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
              Text(AppStrings.addUser, style: AppTypography.kBold24.copyWith(color: AppColors.cTitle)),
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
                          controller: userEditingController,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.cTitle),
                                borderRadius: BorderRadius.circular(AppConstants.radius),
                              ),
                              labelText: AppStrings.email,
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
                          if (state is AddUserLoadingState) {
                            showLoading();
                          } else if (state is AddUserSuccessState) {
                            hideLoading();
                            showSnackBar(context, AppStrings.addSuccess);
                            AddUserDialog.hide(context);
                          } else if (state is AddUserErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                          } else if (state is DashboardNoInternetState) {
                            hideLoading();
                            onError(context, AppStrings.noInternet);
                          }
                        }, builder: (context, state) {
                      return PrimaryButton(
                        onTap: () {
                          if (userEditingController.text.trim() == "") return;
                          AllowedUserModel allowedUserModel =
                          AllowedUserModel(
                              email: userEditingController.text);
                          DashboardCubit.get(context)
                              .addUser(allowedUserModel);
                        },
                        text: AppStrings.add,
                        width: 160.w,
                        gradient: true,
                      );
                    }),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    onTap: () {
                      AddUserDialog.hide(context);
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