import 'package:alaeeeesh/core/utils/constant/app_constants.dart';
import 'package:alaeeeesh/core/utils/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../core/utils/ui_components/primary_button.dart';

class AddPostBottomSheet extends StatefulWidget {
  double statusBarHeight;
  AddPostBottomSheet({super.key, required this.statusBarHeight});

  @override
  State<AddPostBottomSheet> createState() => _AddPostBottomSheetState();
}

class _AddPostBottomSheetState extends State<AddPostBottomSheet> {
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.sizeOf(context).height - widget.statusBarHeight,
          padding: EdgeInsets.all(20.h),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              color: AppColors.cWhite,
              border: Border.all(color: AppColors.cTitle,width: 1.5.w),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(30.r))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomDivider(),
              const Divider(color: AppColors.grey,),
              SizedBox(height: AppConstants.heightBetweenElements),
              Center(
                child: Text(AppStrings.addPost,
                    style: AppTypography.kBold24
                        .copyWith(color: AppColors.cTitle)),
              ),
              SizedBox(
                height: AppConstants.moreHeightBetweenElements,
              ),
              Expanded(
                child: 
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      TextField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          controller: _postController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.w),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.cSecondary),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radius),
                              ),
                              labelText: AppStrings.alsha,
                              border: InputBorder.none)),
                      SizedBox(
                        height: AppConstants.moreHeightBetweenElements,
                      ),
                      PrimaryButton(onTap: () {},text: AppStrings.addAlsha,width: 120.w,gradient: true,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
