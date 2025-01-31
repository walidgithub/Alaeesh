import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../../home_page/data/model/post_model.dart';
import '../../bloc/layout_cubit.dart';
import '../../bloc/layout_state.dart';

class AddPostBottomSheet extends StatefulWidget {
  double statusBarHeight;
  String username;
  String userImage;
  Function postAdded;
  AddPostBottomSheet(
      {super.key,
      required this.statusBarHeight,
      required this.username,
      required this.userImage,
      required this.postAdded});

  @override
  State<AddPostBottomSheet> createState() => _AddPostBottomSheetState();
}

class _AddPostBottomSheetState extends State<AddPostBottomSheet> {
  final TextEditingController _postController = TextEditingController();
  bool _isErrorDialogShown = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.sizeOf(context).height - widget.statusBarHeight,
        padding: EdgeInsets.all(20.h),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: AppColors.cWhite,
            border: Border.all(color: AppColors.cTitle, width: 1.5.w),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomDivider(),
            const Divider(
              color: AppColors.grey,
            ),
            SizedBox(height: AppConstants.heightBetweenElements),
            Center(
              child: Text(AppStrings.addPost,
                  style:
                      AppTypography.kBold24.copyWith(color: AppColors.cTitle)),
            ),
            SizedBox(
              height: AppConstants.moreHeightBetweenElements,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                              borderSide:
                                  const BorderSide(color: AppColors.cSecondary),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius),
                            ),
                            labelText: AppStrings.alsha,
                            border: InputBorder.none)),
                    SizedBox(
                      height: AppConstants.moreHeightBetweenElements,
                    ),
                    BlocProvider(
                      create: (context) => sl<LayoutCubit>(),
                      child: BlocConsumer<LayoutCubit, LayoutState>(
                        listener: (context, state) async {
                          if (state is AddPostLoadingState) {
                            showLoading();
                          } else if (state is AddPostSuccessState) {
                            hideLoading();
                            showSnackBar(context, AppStrings.addSuccess);
                            widget.postAdded(state.addPostResponse.postId);
                            Navigator.pop(context);
                          } else if (state is AddPostErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
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

                              PostModel postModel = PostModel(
                                  userImage: widget.userImage,
                                  username: widget.username,
                                  postAlsha: _postController.text.trim(),
                                  commentsList: [],
                                  emojisList: [],
                                  postSubscribersList: [],
                                  time: '$formattedDate $formattedTime',
                                  lastUpdateTime:
                                      '$formattedDate $formattedTime');
                              LayoutCubit.get(context).addPost(postModel);
                            },
                            text: AppStrings.addAlsha,
                            width: 120.w,
                            gradient: true,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
