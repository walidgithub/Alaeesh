import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/app_pref.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../dashboard/presentation/ui/widgets/add_user_dialog.dart';
import '../../../../welcome/presentation/bloc/welcome_cubit.dart';
import '../../../../welcome/presentation/bloc/welcome_state.dart';

Future<void> showMenuPopupMenu(BuildContext context, SecureStorageLoginHelper appSecureDataHelper, AppPreferences appPreferences, bool addPost,var scaffoldKey, Function updateSearching, String role) async {
  await showMenu(
      context: context,
      color: AppColors.cWhite,
      menuPadding: EdgeInsets.zero,
      elevation: 4,
      position: RelativeRect.fromDirectional(
          textDirection: TextDirection.ltr,
          start: 20.w,
          top: 120.h,
          end: 0.w,
          bottom: 0),
      items: [
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: BlocProvider(
              create: (context) => sl<WelcomeCubit>(),
              child: BlocConsumer<WelcomeCubit, WelcomeState>(
                listener: (context, state) async {
                  if (state is LogoutLoadingState) {
                    showLoading();
                  } else if (state is LogoutSuccessState) {
                    hideLoading();
                    await appSecureDataHelper.clearUserData();
                    await appPreferences.setUserLoggedOut();
                    Navigator.pushReplacementNamed(
                        context, Routes.welcomeRoute);
                  } else if (state is LogoutErrorState) {
                    showSnackBar(context, state.errorMessage);
                    hideLoading();
                  } else if (state is WelcomeNoInternetState) {
                    hideLoading();
                    onError(context, AppStrings.noInternet);
                  }
                },
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cTitle),
                        borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        addPost
                            ? Bounceable(
                          onTap: () {
                            Navigator.pop(context);
                            updateSearching(true);
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                AppAssets.search,
                                width: 30.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                AppStrings.searchForPost,
                                style: AppTypography.kLight12,
                              ),
                            ],
                          ),
                        )
                            : Container(),
                        addPost
                            ? Column(
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7.h,
                            ),
                          ],
                        )
                            : Container(),
                        role == "admin"
                            ?
                        Bounceable(
                          onTap: () {
                            Navigator.pop(context);
                            AddUserDialog.show(
                                context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                AppAssets.profileIcon,
                                width: 30.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                AppStrings.addUser,
                                style: AppTypography.kLight12,
                              ),
                            ],
                          ),
                        )
                            : Container(),
                        role == "admin"
                            ? Column(
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7.h,
                            ),
                          ],
                        ): Container(),
                        Bounceable(
                          onTap: () {
                            Navigator.pop(context);
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                AppAssets.drawer,
                                width: 30.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                AppStrings.showDrawer,
                                style: AppTypography.kLight12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ))
      ]);
}