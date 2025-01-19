import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/dialogs/error_dialog.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/features/home_page/data/model/comments_model.dart';
import 'package:last/features/home_page/data/model/requests/add_comment_request.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/primary_button.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';

class AddCommentBottomSheet extends StatefulWidget {
  double statusBarHeight;
  String username;
  String userImage;
  String id;
  String postId;
  Function addNewComment;
  AddCommentBottomSheet({
    super.key,
    required this.statusBarHeight,
    required this.username,
    required this.userImage,
    required this.id,
    required this.postId,
    required this.addNewComment,
  });

  @override
  State<AddCommentBottomSheet> createState() => _AddCommentBottomSheetState();
}

class _AddCommentBottomSheetState extends State<AddCommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

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
              child: Text(AppStrings.addComment,
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
                          if (state is AddCommentLoadingState) {
                            showLoading();
                          } else if (state is AddCommentSuccessState) {
                            hideLoading();
                            showSnackBar(context, AppStrings.addSuccess);
                            widget.addNewComment(1);
                            Navigator.pop(context);
                          } else if (state is AddCommentErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
                          } else if (state is NoInternetState) {
                            hideLoading();
                            onError(context, AppStrings.noInternet);
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

                              AddCommentRequest addCommentRequest =
                                  AddCommentRequest(
                                      postId: widget.id,
                                      commentsModel: CommentsModel(
                                          postId: widget.id,
                                          username: widget.username,
                                          userImage: widget.userImage,
                                          time: '$formattedDate $formattedTime',
                                          comment:
                                              _commentController.text.trim(),
                                          commentEmojiModel: []),
                                      lastTimeUpdate:
                                          '$formattedDate $formattedTime');
                              HomePageCubit.get(context)
                                  .addComment(addCommentRequest);
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
