import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
import 'package:readmore/readmore.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../welcome/presentation/bloc/welcome_state.dart';
import '../../../data/model/comment_emoji_model.dart';
import '../../../data/model/comments_model.dart';
import '../../../data/model/requests/add_comment_emoji_request.dart';
import '../../../data/model/requests/add_comment_request.dart';
import '../../../domain/entities/emoji_entity.dart';
import '../../bloc/home_page_cubit.dart';
import '../../bloc/home_page_state.dart';
import 'comment_view.dart';

class CommentsBottomSheet extends StatefulWidget {
  String postId;
  String userName;
  String userImage;
  String userEmail;
  String postAlsha;
  double statusBarHeight;
  List<CommentsModel> commentsList;
  Function addNewComment;
  Function addOrRemoveSubscriber;
  Function getUserPosts;
  CommentsBottomSheet(
      {super.key,
      required this.statusBarHeight,
      required this.commentsList,
      required this.postId,
      required this.userName,
      required this.userImage,
      required this.userEmail,
      required this.postAlsha,
      required this.addOrRemoveSubscriber,
      required this.getUserPosts,
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

  Future<void> refresh() async {
    setState(() {
      widget.addNewComment(0, widget.postId);
      Navigator.pop(context);
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
            ReadMoreText(
              widget.postAlsha,
              style: AppTypography.kLight14.copyWith(fontFamily: "Cairo"),
              trimLines: 3,
              colorClickableText: AppColors.cTitle,
              trimMode: TrimMode.Line,
              trimCollapsedText: AppStrings.readMore,
              trimExpandedText: AppStrings.less,
            ),
            SizedBox(
              height: AppConstants.moreHeightBetweenElements,
            ),
            BlocProvider(
              create: (context) =>
                  sl<WelcomeCubit>()..getUserPermissions(widget.userName),
              child: BlocBuilder<WelcomeCubit, WelcomeState>(
                builder: (context, state) {
                  if (state is GetUserPermissionsLoadingState) {
                    return Center(child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: AppColors.cTitle,
                    ));
                  } else if (state is GetUserPermissionsSuccessState) {
                    if (state.userPermissionsModel.enableAdd == "yes") {
                      return Row(
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
                                      borderSide: const BorderSide(
                                          color: AppColors.cSecondary),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radius),
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
                              if (state is AddCommentLoadingState) {
                                showLoading();
                              } else if (state is AddCommentSuccessState) {
                                hideLoading();
                                showSnackBar(context, AppStrings.addSuccess);
                                widget.addNewComment(1, widget.postId);
                                Navigator.pop(context);
                              } else if (state is AddCommentErrorState) {
                                hideLoading();
                                showSnackBar(context, state.errorMessage);
                                Navigator.pop(context);
                              } else if (state is HomePageNoInternetState) {
                                hideLoading();
                                onError(context, AppStrings.noInternet);
                              }
                            }, builder: (context, state) {
                              return Bounceable(
                                  onTap: () {
                                    if (_commentController.text.trim() == "") {
                                      return;
                                    }
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
                                                userImage: widget.userImage,
                                                userEmail: widget.userEmail,
                                                time:
                                                    '$formattedDate $formattedTime',
                                                comment: _commentController.text
                                                    .trim(),
                                                commentEmojiModel: []),
                                            lastTimeUpdate:
                                                '$formattedDate $formattedTime');
                                    HomePageCubit.get(context)
                                        .addComment(addCommentRequest);
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.send,
                                    width: 30.w,
                                  ));
                            }),
                          )
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Divider(),
                          Text(AppStrings.preventMessage,style: AppTypography.kLight16.copyWith(color: AppColors.cPrimaryLight),),
                          Divider()
                        ],
                      );
                    }
                  } else if (state is GetUserPermissionsErrorState ||
                      state is WelcomeNoInternetState) {
                    return SizedBox.shrink();
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
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
                      return BlocProvider(
                          create: (context) => sl<HomePageCubit>(),
                          child: BlocConsumer<HomePageCubit, HomePageState>(
                              listener: (context, state) {
                            if (state is AddCommentEmojiLoadingState) {
                              showLoading();
                            } else if (state is AddCommentEmojiSuccessState) {
                              hideLoading();
                              if (userReacted) {
                                widget.addNewComment(0, widget.postId);
                              } else {
                                widget.addNewComment(1, widget.postId);
                              }
                              Navigator.pop(context);
                            } else if (state is AddCommentEmojiErrorState) {
                              hideLoading();
                              showSnackBar(context, state.errorMessage);
                              Navigator.pop(context);
                            } else if (state
                                is DeleteCommentEmojiLoadingState) {
                              showLoading();
                            } else if (state
                                is DeleteCommentEmojiSuccessState) {
                              hideLoading();
                            } else if (state is DeleteCommentEmojiErrorState) {
                              hideLoading();
                              showSnackBar(context, state.errorMessage);
                              Navigator.pop(context);
                            } else if (state is HomePageNoInternetState) {
                              hideLoading();
                              onError(context, AppStrings.noInternet);
                            }
                          }, builder: (context, state) {
                            return CommentView(
                              getUserPosts: (String userName) {
                                widget.getUserPosts(userName);
                              },
                              userEmail: widget.userEmail,
                              addOrRemoveSubscriber: (int status) {
                                widget.addOrRemoveSubscriber(status);
                              },
                              loggedInUserEmail: widget.commentsList[index].userEmail,
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
                              addNewCommentEmoji:
                                  (EmojiEntity returnedEmojiData) {
                                userReacted = widget
                                    .commentsList[0].commentEmojiModel
                                    .where((element) =>
                                        element.username == widget.userName)
                                    .isNotEmpty;

                                DateTime now = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(now);
                                String formattedTime =
                                    DateFormat('hh:mm a').format(now);

                                AddCommentEmojiRequest addCommentEmojiRequest =
                                    AddCommentEmojiRequest(
                                        postId: widget.commentsList[0].postId,
                                        commentEmojiModel: CommentEmojiModel(
                                            commentId:
                                                widget.commentsList[index].id!,
                                            postId:
                                                widget.commentsList[0].postId,
                                            userEmail: widget.userEmail,
                                            emojiData:
                                                returnedEmojiData.emojiData,
                                            username: widget.userName,
                                            userImage: widget.userImage),
                                        lastTimeUpdate:
                                            '$formattedDate $formattedTime');
                                HomePageCubit.get(context)
                                    .addCommentEmoji(addCommentEmojiRequest);
                              },
                              updateComment: (int status, String id) {
                                widget.addNewComment(status, widget.postId);
                                Navigator.pop(context);
                              },
                            );
                          }));
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
