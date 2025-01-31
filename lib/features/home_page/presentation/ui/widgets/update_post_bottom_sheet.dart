import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:last/features/home_page/data/model/requests/update_post_request.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../data/model/post_model.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';

class UpdatePostBottomSheet extends StatefulWidget {
  double statusBarHeight;
  PostModel postModel;
  Function postUpdated;
  UpdatePostBottomSheet(
      {super.key,
      required this.statusBarHeight,
      required this.postModel,
      required this.postUpdated});

  @override
  State<UpdatePostBottomSheet> createState() => _UpdatePostBottomSheetState();
}

class _UpdatePostBottomSheetState extends State<UpdatePostBottomSheet> {
  final TextEditingController _postController = TextEditingController();
  bool _isErrorDialogShown = false;
  @override
  void initState() {
    _postController.text = widget.postModel.postAlsha;
    super.initState();
  }

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
              child: Text(AppStrings.updatePost,
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
                      create: (context) => sl<HomePageCubit>(),
                      child: BlocConsumer<HomePageCubit, HomePageState>(
                        listener: (context, state) async {
                          if (state is UpdatePostLoadingState) {
                            showLoading();
                          } else if (state is UpdatePostSuccessState) {
                            hideLoading();
                            showSnackBar(
                                context, AppStrings.updatedSuccessfully);
                            widget.postUpdated();
                            Navigator.pop(context);
                          } else if (state is UpdatePostErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
                          } else if (state is HomePageNoInternetState) {
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

                              UpdatePostRequest updatePostRequest =
                                  UpdatePostRequest(
                                      postId: widget.postModel.id!,
                                      postModel: PostModel(
                                          id: widget.postModel.id,
                                          userImage: widget.postModel.userImage,
                                          username: widget.postModel.username,
                                          postAlsha:
                                              _postController.text.trim(),
                                          commentsList:
                                              widget.postModel.commentsList,
                                          emojisList:
                                              widget.postModel.emojisList,
                                          postSubscribersList: widget
                                              .postModel.postSubscribersList,
                                          lastUpdateTime:
                                              '$formattedDate $formattedTime'));
                              HomePageCubit.get(context)
                                  .updatePost(updatePostRequest);
                            },
                            text: AppStrings.addSuccess,
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
