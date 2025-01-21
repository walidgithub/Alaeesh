import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_strings.dart';
import '../constant/app_typography.dart';
import '../style/app_colors.dart';

Future<bool> onBackButtonPressed(BuildContext context) async {
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
                    color: AppColors.cSecondary,
                    padding: EdgeInsets.all(15.w),
                    child: Text(
                      AppStrings.warning,
                      style: AppTypography.kBold24.copyWith(color: AppColors.cWhite),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w), // Content padding
                    child: Text(
                      AppStrings.closeApp,
                      style: AppTypography.kBold16.copyWith(color: AppColors.cTitle),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          SystemNavigator.pop();
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
                          AppStrings.yes,
                          style: AppTypography.kLight16.copyWith(color: AppColors.cPrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
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
                          AppStrings.no,
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



