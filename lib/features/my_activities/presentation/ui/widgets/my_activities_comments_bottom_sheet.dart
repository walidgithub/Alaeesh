import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/preferences/app_pref.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../home_page/data/model/comments_model.dart';
import '../../bloc/my_activities_cubit.dart';
import '../../bloc/my_activities_state.dart';
import 'my_activities_comment_view.dart';

class MyActivitiesCommentsBottomSheet extends StatefulWidget {
  String postId;
  String userName;
  String userImage;
  String postAlsha;
  double statusBarHeight;
  List<CommentsModel> commentsList;
  Function updateComment;
  MyActivitiesCommentsBottomSheet(
      {super.key,
      required this.statusBarHeight,
      required this.commentsList,
      required this.postId,
      required this.userName,
      required this.userImage,
      required this.postAlsha,
      required this.updateComment,
      });

  @override
  State<MyActivitiesCommentsBottomSheet> createState() => _MyActivitiesCommentsBottomSheetState();
}

class _MyActivitiesCommentsBottomSheetState extends State<MyActivitiesCommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();
  bool textAutofocus = false;
  String commentId = "";
  var commentData;
  bool userReacted = false;

  @override
  void initState() {
    getCommentId();
    super.initState();
  }

  // void goToLastItem() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.linear,
  //       );
  //     }
  //   });
  // }

  Future<void> getCommentId() async {
    commentData = await _appSecureDataHelper.loadCommentData();
    setState(() {
      commentId = commentData['id'] ?? '';
    });
    scrollToItemWithComment(commentId);
  }

  void scrollToItemWithComment(String targetComment) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int index =
          widget.commentsList.indexWhere((item) => item.id == targetComment);

      if (index != -1 && _scrollController.hasClients) {
        double offset = 0.0;

        for (int i = 0; i < index; i++) {
          offset += calculateItemHeight(i);
        }

        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  double calculateItemHeight(int index) {
    return 140.h;
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
              child: Text(AppStrings.comments,
                  style:
                      AppTypography.kBold24.copyWith(color: AppColors.cTitle)),
            ),
            SizedBox(
              height: AppConstants.moreHeightBetweenElements,
            ),
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlocProvider(
                        create: (context) => sl<MyActivitiesCubit>(),
                        child: BlocConsumer<MyActivitiesCubit, MyActivitiesState>(
                            listener: (context, state) {
                          if (state is DeleteCommentEmojiErrorState) {
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
                          }
                        }, builder: (context, state) {
                          return MyActivitiesCommentView(
                            index: index,
                            id: widget.commentsList[index].id!,
                            username: widget.commentsList[index].username,
                            time: widget.commentsList[index].time,
                            comment: widget.commentsList[index].comment,
                            userImage: widget.commentsList[index].userImage,
                            loggedInUserImage: widget.userImage,
                            loggedInUserName: widget.userName,
                            commentEmojisModel:
                                widget.commentsList[index].commentEmojiModel,
                            statusBarHeight: widget.statusBarHeight,
                            postId: widget.commentsList[index].postId,
                            updateComment: (int status) {
                              widget.updateComment(status);
                            },
                          );
                        }));
                  },
                  itemCount: widget.commentsList.length),
            )
          ],
        ),
      ),
    ));
  }
}
