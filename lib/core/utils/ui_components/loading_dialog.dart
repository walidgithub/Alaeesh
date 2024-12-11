import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_strings.dart';
import '../style/app_colors.dart';

void showLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.cPrimary
    ..indicatorColor = AppColors.cWhite
    ..textColor = AppColors.cWhite
    ..indicatorSize = 50.0.w
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..radius = 10.0.w
    ..dismissOnTap = false
    ..userInteractions = false;
  EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
    status: AppStrings.loading,
  );
}

void hideLoading() {
  EasyLoading.dismiss();
}
