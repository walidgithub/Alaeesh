import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/constant/app_assets.dart';
import 'package:last/core/utils/constant/app_typography.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/layout/presentation/bloc/layout_cubit.dart';
import 'package:launch_app_store/launch_app_store.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../data/model/requests/send_advise_request.dart';
import '../../bloc/layout_state.dart';
import 'dart:ui' as ui;

class DrawerInfo extends StatefulWidget {
  const DrawerInfo({super.key});

  @override
  State<DrawerInfo> createState() => _DrawerInfoState();
}

class _DrawerInfoState extends State<DrawerInfo> {
  final TextEditingController _adviseUsController = TextEditingController();
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  var userData;
  bool _isErrorDialogShown = false;
  @override
  void initState() {
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    super.initState();
  }

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cWhite,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppStrings.adviseUs,
                  style: AppTypography.kBold22
                      .copyWith(color: AppColors.cSecondary),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    controller: _adviseUsController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.w),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.cSecondary),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radius),
                        ),
                        labelText: AppStrings.advice,
                        border: InputBorder.none)),
                SizedBox(
                  height: AppConstants.moreHeightBetweenElements,
                ),
                BlocProvider(
                  create: (context) => sl<LayoutCubit>(),
                  child: BlocConsumer<LayoutCubit, LayoutState>(
                    listener: (context, state) async {
                      if (state is SendAdviceLoadingState) {
                        showLoading();
                      } else if (state is SendAdviceSuccessState) {
                        hideLoading();
                        showSnackBar(context, AppStrings.addSuccess);
                        Navigator.pop(context);
                      } else if (state is SendAdviceErrorState) {
                        hideLoading();
                        showSnackBar(context, state.errorMessage);
                      } else if (state is LayoutNoInternetState) {
                        hideLoading();
                        setState(() {
                          _isErrorDialogShown = true;
                        });
                        if (_isErrorDialogShown) {
                          onError(context, AppStrings.noInternet, () {
                            setState(() {
                              _isErrorDialogShown = false;
                            });
                          });
                        }
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        onTap: () {
                          DateTime now = DateTime.now();
                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(now);
                          String formattedTime =
                          DateFormat('hh:mm a').format(now);

                          SendAdviceRequest sendAdviceRequest =
                              SendAdviceRequest(
                            adviceText: _adviseUsController.text,
                            username: displayName,
                            userImage: photoUrl,
                            time: '$formattedDate $formattedTime',
                          );
                          LayoutCubit.get(context)
                              .sendAdvice(sendAdviceRequest);
                        },
                        text: AppStrings.addAlsha,
                        width: 120.w,
                        gradient: true,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Divider(),
                Text(
                  AppStrings.about,
                  style: AppTypography.kBold22
                      .copyWith(color: AppColors.cSecondary),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  AppStrings.info,
                  style: TextStyle(fontSize: 15.sp, color: AppColors.cBlack),
                  textDirection: ui.TextDirection.rtl,
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 5.w),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.rating,
                        style: AppTypography.kBold22
                            .copyWith(color: AppColors.cSecondary),
                      ),
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      Bounceable(
                        onTap: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 700));
                          LaunchReview.launch(
                              androidAppId: "com.iyaffle.kural");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                            SvgPicture.asset(
                              AppAssets.rate,
                              width: 25.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
