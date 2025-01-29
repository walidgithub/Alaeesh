import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_states.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/app_pref.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/dialogs/back_dialog.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/ui_components/curved_clipper.dart';
import '../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../core/utils/ui_components/primary_button.dart';
import '../../../../core/utils/ui_components/snackbar.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final AppPreferences _appPreferences = sl<AppPreferences>();
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: SafeArea(
          child: Scaffold(
        body: bodyContent(context),
      )),
    );
  }

  Widget bodyContent(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  width: MediaQuery.of(context).size.width,
                  child: ClipPath(
                    clipper: CurvedClipper(),
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        AppAssets.welcome,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width,
                  child: ClipPath(
                    clipper: CurvedClipper(),
                    child: Image.asset(
                      AppAssets.welcome,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInLeft(
                          duration:
                              Duration(milliseconds: AppConstants.animation),
                          child: Row(
                            children: [
                              Text(AppStrings.welcome,
                                  style: AppTypography.kBold36),
                              Image.asset(
                                AppAssets.splash,
                                width: MediaQuery.of(context).size.width / 3,
                              )
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        SizedBox(
                          height: AppConstants.moreHeightBetweenElements,
                        ),
                        FadeInRight(
                          duration:
                              Duration(milliseconds: AppConstants.animation),
                          child: BlocProvider(
                            create: (context) => sl<WelcomeCubit>(),
                            child: BlocConsumer<WelcomeCubit, WelcomeState>(
                              listener: (context, state) async {
                                if (state is LoginLoadingState) {
                                  showLoading();
                                } else if (state is LoginSuccessState) {
                                  hideLoading();
                                  await _appSecureDataHelper.saveUserData(
                                      id: state.user.id!,
                                      email: state.user.email!,
                                      displayName: state.user.name!,
                                      photoUrl: state.user.photoUrl!);
                                  await _appPreferences.setUserLoggedIn();
                                  Navigator.pushReplacementNamed(
                                      context, Routes.layoutRoute);
                                } else if (state is LoginErrorState) {
                                  showSnackBar(context, state.errorMessage);
                                  hideLoading();
                                } else if (state is WelcomeNoInternetState) {
                                  hideLoading();
                                  onError(context, AppStrings.noInternet);
                                }
                              },
                              builder: (context, state) {
                                return PrimaryButton(
                                  onTap: () {
                                    WelcomeCubit.get(context).login();
                                  },
                                  text: AppStrings.google,
                                  width: 200.w,
                                  gradient: false,
                                  child: SvgPicture.asset(
                                    AppAssets.google,
                                    width: 30.w,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
