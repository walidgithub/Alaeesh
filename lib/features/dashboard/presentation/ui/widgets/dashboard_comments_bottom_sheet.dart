import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../home_page/data/model/comments_model.dart';
import 'dashboard_comment_view.dart';

class DashboardCommentsBottomSheet extends StatefulWidget {
  String postId;
  String userName;
  String userImage;
  String postAlsha;
  double statusBarHeight;
  List<CommentsModel> commentsList;
  Function addNewComment;
  DashboardCommentsBottomSheet(
      {super.key,
        required this.statusBarHeight,
        required this.commentsList,
        required this.postId,
        required this.userName,
        required this.userImage,
        required this.postAlsha,
        required this.addNewComment});

  @override
  State<DashboardCommentsBottomSheet> createState() => _DashboardCommentsBottomSheetState();
}

class _DashboardCommentsBottomSheetState extends State<DashboardCommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool textAutofocus = false;
  String commentId = "";
  var commentData;
  bool userReacted = false;

  Future<void> refresh() async {
    setState(() {
      widget.addNewComment(0);
      Navigator.pop(context);
    });
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
                ReadMoreText(
                  widget.postAlsha,
                  style: AppTypography.kLight14,
                  trimLines: 3,
                  colorClickableText: AppColors.cTitle,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: AppStrings.readMore,
                  trimExpandedText: AppStrings.less,
                ),
                SizedBox(
                  height: AppConstants.moreHeightBetweenElements,
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.cTitle,
                    backgroundColor: AppColors.cWhite,
                    onRefresh: refresh,
                    child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return DashboardCommentView(
                            index: index,
                            id: widget.commentsList[index].id!,
                            username: widget.commentsList[index].username,
                            time: widget.commentsList[index].time!,
                            comment: widget.commentsList[index].comment,
                            userImage: widget.commentsList[index].userImage,
                            loggedInUserImage: widget.userImage,
                            loggedInUserName: widget.userName,
                            commentEmojisModel:
                            widget.commentsList[index].commentEmojiModel,
                            statusBarHeight: widget.statusBarHeight,
                            postId: widget.commentsList[index].postId,
                            updateComment: (int status) {
                              widget.addNewComment(status);
                              Navigator.pop(context);
                            },
                          );
                        },
                        itemCount: widget.commentsList.length),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
