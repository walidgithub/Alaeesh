import 'package:alaeeeesh/core/utils/constant/app_assets.dart';
import 'package:alaeeeesh/core/utils/constant/app_constants.dart';
import 'package:alaeeeesh/core/utils/constant/app_strings.dart';
import 'package:alaeeeesh/core/utils/style/app_colors.dart';
import 'package:alaeeeesh/core/utils/ui_components/custom_divider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/dialogs/back_dialog.dart';
import '../../../../core/utils/ui_components/curved_clipper.dart';
import '../../../../core/utils/ui_components/primary_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: SafeArea(child: Scaffold(
        body: Directionality(textDirection: TextDirection.rtl ,child: bodyContent(context)),
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
                          duration: Duration(milliseconds: AppConstants.animation),
                          child: Row(
                            children: [
                              Text(AppStrings.welcome ,style: AppTypography.kBold36),
                              Image.asset(AppAssets.splash, width: MediaQuery.of(context).size.width / 3,)
                            ],
                          ),
                        ),
                        const CustomDivider(),
                        SizedBox(
                          height: AppConstants.moreHeightBetweenElements,
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: AppConstants.animation),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PrimaryButton(onTap: () {},text: AppStrings.guest,width: 120.w,gradient: true,),
                              SizedBox(width: 20.w,),
                              PrimaryButton(onTap: () {},text: AppStrings.google,width: 200.w,gradient: false,child: SvgPicture.asset(AppAssets.google,width: 30.w,),),
                            ],
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

