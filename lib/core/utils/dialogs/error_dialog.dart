import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_strings.dart';
import '../constant/app_typography.dart';

Future<bool> onError(BuildContext context, String errorText) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.error,style: AppTypography.kBold24,),
          content: Text(errorText,style: AppTypography.kBold16),
          actions: [
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppStrings.close,style: AppTypography.kLight14)),
            ),
          ],
        );
      });
  return exitApp;
}
