import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../data/model/comment_emoji_model.dart';
import '../../../data/model/comments_model.dart';
import '../../../data/model/requests/add_comment_emoji_request.dart';
import '../../../data/model/requests/add_comment_request.dart';
import '../../../data/model/requests/add_subscriber_request.dart';
import '../../../data/model/requests/delete_subscriber_request.dart';
import '../../../data/model/subscribers_model.dart';
import '../../../domain/entities/emoji_entity.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';
import 'comment_view.dart';

class CommentsBottomSheet extends StatefulWidget {
  String postId;
  String userName;
  String userImage;
  double statusBarHeight;
  List<CommentsModel> commentsList;
  Function addNewComment;
  CommentsBottomSheet(
      {super.key,
      required this.statusBarHeight,
      required this.commentsList,
      required this.postId,
      required this.userName,
      required this.userImage,
      required this.addNewComment});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
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
      } else {
        print("No item with the comment '$targetComment' found");
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
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: TextField(
                      onTap: () {
                        setState(() {
                          textAutofocus = true;
                        });
                      },
                      onTapOutside: (done) {
                        setState(() {
                          textAutofocus = false;
                        });
                      },
                      onSubmitted: (done) {
                        setState(() {
                          textAutofocus = false;
                        });
                      },
                      autofocus: textAutofocus,
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
                ),
                SizedBox(
                  width: 10.w,
                ),
                BlocProvider(
                  create: (context) => sl<HomePageCubit>(),
                  child: BlocConsumer<HomePageCubit, HomePageState>(
                      listener: (context, state) {
                    if (state is AddCommentSuccessState) {
                      showSnackBar(context, AppStrings.addSuccess);
                      widget.addNewComment(1);
                      Navigator.pop(context);
                    } else if (state is AddCommentErrorState) {
                      showSnackBar(context, state.errorMessage);
                      Navigator.pop(context);
                    }
                  }, builder: (context, state) {
                    return Bounceable(
                        onTap: () {
                          if (_commentController.text.trim() == "") return;
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
                          String formattedTime =
                              DateFormat('hh:mm a').format(now);

                          AddCommentRequest addCommentRequest =
                              AddCommentRequest(
                                  postId: widget.postId,
                                  commentsModel: CommentsModel(
                                      postId: widget.postId,
                                      username: widget.userName,
                                      userImage:
                                          widget.userImage,
                                      time: '$formattedDate $formattedTime',
                                      comment: _commentController.text.trim(),
                                      commentEmojiModel: []));
                          HomePageCubit.get(context)
                              .addComment(addCommentRequest);
                        },
                        child: SvgPicture.asset(
                          AppAssets.comments,
                          width: 30.w,
                        ));
                  }),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlocProvider(
                        create: (context) => sl<HomePageCubit>(),
                        child: BlocConsumer<HomePageCubit, HomePageState>(
                            listener: (context, state) {
                          if (state is AddCommentEmojiSuccessState) {
                            if (userReacted) {
                              widget.addNewComment(0);
                            } else {
                              widget.addNewComment(1);
                            }
                            Navigator.pop(context);
                          } else if (state is AddCommentEmojiErrorState) {
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
                          } else if (state is DeleteCommentEmojiErrorState) {
                            showSnackBar(context, state.errorMessage);
                            Navigator.pop(context);
                          }
                        }, builder: (context, state) {
                          return CommentView(
                            index: index,
                            id: widget.commentsList[index].id!,
                            username: widget.commentsList[index].username,
                            time: widget.commentsList[index].time,
                            comment: widget.commentsList[index].comment,
                            userImage: widget.commentsList[index].userImage,
                            commentEmojisModel:
                                widget.commentsList[index].commentEmojiModel,
                            statusBarHeight: widget.statusBarHeight,
                            postId: widget.commentsList[index].postId,
                            addNewCommentEmoji:
                                (EmojiEntity returnedEmojiData) {
                                  userReacted = widget.commentsList[0].commentEmojiModel.where(
                                          (element) => element.username == widget.userName).isNotEmpty;

                              AddCommentEmojiRequest addCommentEmojiRequest =
                                  AddCommentEmojiRequest(
                                      postId: widget.commentsList[0].postId,
                                      commentEmojiModel: CommentEmojiModel(
                                          commentId:
                                              widget.commentsList[index].id!,
                                          postId: widget.commentsList[0].postId,
                                          emojiData:
                                              returnedEmojiData.emojiData,
                                          username:
                                              widget.commentsList[0].username,
                                          userImage: widget
                                              .commentsList[0].userImage));
                              HomePageCubit.get(context)
                                  .addCommentEmoji(addCommentEmojiRequest);
                            },
                            updateComment: (int status) {
                              widget.addNewComment(status);
                              Navigator.pop(context);
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
