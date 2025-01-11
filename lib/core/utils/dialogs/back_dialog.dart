import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_strings.dart';
import '../constant/app_typography.dart';
import '../style/app_colors.dart';

Future<bool> onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(AppStrings.warning,style: AppTypography.kBold24.copyWith(color: AppColors.cSecondary),),
            content: Text(AppStrings.closeApp,style: AppTypography.kBold16.copyWith(color: AppColors.cTitle)),
            actions: [
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(AppStrings.yes,style: AppTypography.kLight16.copyWith(color: AppColors.cPrimary))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppStrings.no,style: AppTypography.kLight14.copyWith(color: AppColors.cTitle))),
            ],
          ),
        );
      });
  return exitApp;
}
