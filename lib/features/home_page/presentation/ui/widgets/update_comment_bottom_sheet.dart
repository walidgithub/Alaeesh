import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/home_page/data/model/comments_model.dart';
import 'package:last/features/home_page/data/model/requests/update_comment_request.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';

class UpdateCommentBottomSheet extends StatefulWidget {
  double statusBarHeight;
  CommentsModel commentModel;
  Function updateComment;
  UpdateCommentBottomSheet({
    super.key,
    required this.statusBarHeight,
    required this.commentModel,
    required this.updateComment,
  });

  @override
  State<UpdateCommentBottomSheet> createState() =>
      _UpdateCommentBottomSheetState();
}

class _UpdateCommentBottomSheetState extends State<UpdateCommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isErrorDialogShown = false;
  @override
  void initState() {
    _commentController.text = widget.commentModel.comment;
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
              child: Text(AppStrings.editComment,
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
                        controller: _commentController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.w),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.cSecondary),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius),
                            ),
                            labelText: AppStrings.addComment,
                            border: InputBorder.none)),
                    SizedBox(
                      height: AppConstants.moreHeightBetweenElements,
                    ),
                    BlocProvider(
                      create: (context) => sl<HomePageCubit>(),
                      child: BlocConsumer<HomePageCubit, HomePageState>(
                        listener: (context, state) async {
                          if (state is UpdateCommentLoadingState) {
                            showLoading();
                          } else if (state is UpdateCommentSuccessState) {
                            hideLoading();
                            showSnackBar(context, AppStrings.addSuccess);
                            widget.updateComment(0);
                            Navigator.pop(context);
                          } else if (state is UpdateCommentErrorState) {
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

                              UpdateCommentRequest updateCommentRequest =
                                  UpdateCommentRequest(
                                      postId: widget.commentModel.postId,
                                      commentsModel: CommentsModel(
                                          id: widget.commentModel.id,
                                          postId: widget.commentModel.postId,
                                          username:
                                              widget.commentModel.username,
                                          userImage:
                                              widget.commentModel.userImage,
                                          comment:
                                              _commentController.text.trim(),
                                          commentEmojiModel: widget
                                              .commentModel.commentEmojiModel),
                                      lastTimeUpdate:
                                          '$formattedDate $formattedTime');
                              HomePageCubit.get(context)
                                  .updateComment(updateCommentRequest);
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
