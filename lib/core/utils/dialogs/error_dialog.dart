import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/core/utils/style/app_colors.dart';

import '../constant/app_strings.dart';
import '../constant/app_typography.dart';

Future<bool> onError(BuildContext context, String errorText, Function closeDialog) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: AppColors.cWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                color: AppColors.cTransparent,
                width: 2.0,
              ),
            ),
            child: Container(
              padding: EdgeInsets.zero, // Remove all padding from the container
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize dialog height
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: AppColors.cPrimary,
                    padding: EdgeInsets.all(15.w),
                    child: Text(
                      AppStrings.error,
                      style: AppTypography.kBold24.copyWith(color: AppColors.cWhite),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w), // Content padding
                    child: Text(
                      errorText,
                      style: AppTypography.kBold16.copyWith(color: AppColors.cTitle),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          closeDialog();
                          Navigator.of(context).pop(false);
                        },
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: AppColors.cTitle, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r), // Rounded corners
                            ),
                          ),
                        ),
                        child: Text(
                          AppStrings.ok,
                          style: AppTypography.kLight14.copyWith(color: AppColors.cTitle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
  return exitApp;
}
