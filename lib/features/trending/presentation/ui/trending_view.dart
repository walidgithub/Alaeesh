import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:last/features/trending/data/model/requests/check_if_user_subscribed_request.dart';
import 'package:last/features/trending/presentation/ui/widgets/suggested_user_view.dart';
import 'package:last/features/trending/presentation/ui/widgets/user_subscriptions_bottom_sheet.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/arguments.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_subscribers_model.dart';
import '../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../home_page/data/model/requests/send_notification_request.dart';
import '../../../home_page/data/model/subscribers_model.dart';
import '../../../home_page/presentation/ui/widgets/comments_bottom_sheet.dart';
import '../../../home_page/presentation/ui/widgets/post_view.dart';
import '../../data/model/requests/get_suggested_user_posts_request.dart';
import '../../data/model/requests/get_top_posts_request.dart';
import '../../data/model/suggested_user_model.dart';
import '../bloc/trending_cubit.dart';
import '../bloc/trending_state.dart';
import 'dart:ui' as ui;

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  int selectedPost = 0;
  String selectedId = "";
  bool showUserSubscriptionsSheet = false;
  bool showCommentBottomSheet = false;
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  String selectedUserName = "";
  bool userSubscribed = false;

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  String role = "";
  String enableAdd = "";

  List<SubscribersModel> subscribersList = [];
  var userData;

  var notificationType = {"active": false, "status": 0, "type": "", "postId":""};

  @override
  void initState() {
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    super.initState();
  }

  Future<void> refresh() async {
    setState(() {
      TrendingCubit.get(context)
          .getTopPosts(GetTopPostsRequest(currentUser: displayName));
    });
  }

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
      role = userData['role'] ?? '';
      
    });
    getTopPosts(displayName);
    getSuggestedUsers();

  }

  getTopPosts(String displayName) {
    TrendingCubit.get(context)
        .getTopPosts(GetTopPostsRequest(currentUser: displayName));
  }

  getSuggestedUsers() {
    TrendingCubit.get(context).getSuggestedUsers();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
        child: Scaffold(
      body: bodyContent(context, statusBarHeight),
    ));
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return BlocConsumer<TrendingCubit, TrendingState>(
      listener: (context, state) async {
        if (state is GetTopPostsLoadingState) {
          showLoading();
        } else if (state is GetTopPostsSuccessState) {
          hideLoading();
          trendingModel.clear();
          trendingModel.addAll(state.homePageModel);
          selectedPost = trendingModel.indexWhere((element) => element.postModel.id == selectedId);
          if (showCommentBottomSheet &&
              trendingModel[selectedPost].postModel.commentsList.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              constraints: BoxConstraints.expand(
                  height: MediaQuery.sizeOf(context).height -
                      statusBarHeight -
                      50.h,
                  width: MediaQuery.sizeOf(context).width),
              isScrollControlled: true,
              barrierColor: AppColors.cTransparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.r),
                ),
              ),
              builder: (context2) {
                return Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: CommentsBottomSheet(
                    role: role,
                    getUserPosts: (String userName) {
                      TrendingCubit.get(context).getTopPosts(
                          GetTopPostsRequest(currentUser: displayName));
                    },
                    addOrRemoveSubscriber: (int status) {
                      if (status == -1) {
                        DeleteSubscriberRequest deleteSubscriberRequest =
                            DeleteSubscriberRequest(
                                username: displayName,
                                postAuther: trendingModel[selectedPost]
                                    .postModel
                                    .username);
                        TrendingCubit.get(context)
                            .deleteSubscriber(deleteSubscriberRequest);
                      } else if (status == 1) {
                        AddSubscriberRequest addSubscriberRequest =
                            AddSubscriberRequest(
                                username: displayName,
                                postAuther: trendingModel[selectedPost]
                                    .postModel
                                    .username);
                        TrendingCubit.get(context)
                            .addSubscriber(addSubscriberRequest);
                      }
                    },
                    postId: trendingModel[selectedPost]
                        .postModel
                        .commentsList[0]
                        .postId,
                    userName: displayName,
                    userImage: photoUrl,
                    userEmail: email,
                    addNewComment: (int status, String returnedId) {
                      setState(() {
                        selectedId = returnedId;
                        showCommentBottomSheet = true;
                        notificationType["active"] = true;
                        notificationType["status"] = status;
                        notificationType["type"] = "comment";
                        notificationType["postId"] = homePageModel[selectedPost].postModel.id!;
                      });
                      if (status == 1) {
                        AddPostSubscriberRequest addPostSubscriberRequest =
                            AddPostSubscriberRequest(
                                postSubscribersModel: PostSubscribersModel(
                          username: displayName,
                          userImage: photoUrl,
                          userEmail: email,
                          postId: trendingModel[selectedPost].postModel.id!,
                        ));
                        TrendingCubit.get(context)
                            .addPostSubscriber(addPostSubscriberRequest);
                      } else if (status == -1) {
                        DeletePostSubscriberRequest
                            deletePostSubscriberRequest =
                            DeletePostSubscriberRequest(
                                postSubscribersModel: PostSubscribersModel(
                          username: displayName,
                          userImage: photoUrl,
                          userEmail: email,
                          postId: trendingModel[selectedPost].postModel.id!,
                        ));
                        TrendingCubit.get(context)
                            .deletePostSubscriber(deletePostSubscriberRequest);
                      } else if (status == 0) {
                        TrendingCubit.get(context).getTopPosts(
                            GetTopPostsRequest(currentUser: displayName));
                      }
                    },
                    statusBarHeight: statusBarHeight,
                    commentsList:
                        trendingModel[selectedPost].postModel.commentsList,
                    postAlsha: trendingModel[selectedPost].postModel.postAlsha,
                  ),
                );
              },
            );
            setState(() {
              showCommentBottomSheet = false;
            });
          }

          if (notificationType["active"] == true) {
            if (notificationType["status"] == 1) {
              DateTime now = DateTime.now();
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(now);
              String formattedTime =
              DateFormat('hh:mm a').format(now);
              if (notificationType["type"] == "comment") {
                SendNotificationRequest sendNotificationRequest =
                SendNotificationRequest(
                    postAuther: displayName,
                    postId: notificationType["postId"].toString(),
                    time: '$formattedDate $formattedTime',
                    userImage: photoUrl,
                    message:
                    '$displayName${AppStrings.newCommentAddedNotification}',
                    seen: false);
                TrendingCubit.get(context)
                    .sendGeneralNotification(sendNotificationRequest);
              } else if (notificationType["type"] == "emoji") {
                SendNotificationRequest sendNotificationRequest =
                SendNotificationRequest(
                    postAuther: displayName,
                    postId: notificationType["postId"].toString(),
                    userImage: photoUrl,
                    time: '$formattedDate $formattedTime',
                    message:
                    '$displayName${AppStrings.newEmojiAddedNotification}',
                    seen: false);
                TrendingCubit.get(context)
                    .sendGeneralNotification(sendNotificationRequest);
              }
            }
          }
        } else if (state is GetTopPostsErrorState) {
          showSnackBar(context, state.errorMessage);
          hideLoading();
        } else if (state is GetSuggestedUsersLoadingState) {
          showLoading();
        } else if (state is GetSuggestedUsersSuccessState) {
          hideLoading();
          suggestedUserModel.clear();
          suggestedUserModel.addAll(state.suggestedUserModel);
          suggestedUserModel
              .removeWhere((element) => element.userName == displayName);
        } else if (state is GetSuggestedUsersErrorState) {
          showSnackBar(context, state.errorMessage);
          hideLoading();
        } else if (state is AddSubscriberLoadingState) {
          showLoading();
        } else if (state is AddSubscriberSuccessState) {
          hideLoading();
          if (showUserSubscriptionsSheet) {
            Navigator.pop(context);
            setState(() {
              showUserSubscriptionsSheet = false;
            });
          }
          TrendingCubit.get(context)
              .getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is AddSubscriberErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        } else if (state is DeleteSubscriberLoadingState) {
          showLoading();
        } else if (state is DeleteSubscriberSuccessState) {
          hideLoading();
          if (showUserSubscriptionsSheet) {
            Navigator.pop(context);
            setState(() {
              showUserSubscriptionsSheet = false;
            });
          }
          TrendingCubit.get(context)
              .getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is DeleteSubscriberErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        } else if (state is CheckIfUserSubscribedLoadingState) {
          showLoading();
        } else if (state is CheckIfUserSubscribedSuccessState) {
          hideLoading();
          setState(() {
            userSubscribed = state.checkIfUserSubscribed;
          });

          GetSuggestedUserPostsRequest getSuggestedUserPostsRequest =
              GetSuggestedUserPostsRequest(userName: selectedUserName);
          TrendingCubit.get(context)
              .getSuggestedUserPosts(getSuggestedUserPostsRequest);
        } else if (state is CheckIfUserSubscribedErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        } else if (state is GetSuggestedUserPostsLoadingState) {
          showLoading();
        } else if (state is GetSuggestedUserPostsSuccessState) {
          hideLoading();

          setState(() {
            showUserSubscriptionsSheet = true;
          });
          showModalBottomSheet(
            context: context,
            constraints: BoxConstraints.expand(
                height:
                    MediaQuery.sizeOf(context).height - statusBarHeight - 50.h,
                width: MediaQuery.sizeOf(context).width),
            isScrollControlled: true,
            barrierColor: AppColors.cTransparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            builder: (context2) {
              return Directionality(
                textDirection: ui.TextDirection.rtl,
                child: UserSubscriptionsBottomSheet(
                  addOrRemoveSubscriber: (int status) {
                    if (status == -1) {
                      DeleteSubscriberRequest deleteSubscriberRequest =
                          DeleteSubscriberRequest(
                              username: displayName,
                              postAuther: selectedUserName);
                      TrendingCubit.get(context)
                          .deleteSubscriber(deleteSubscriberRequest);
                    } else if (status == 1) {
                      AddSubscriberRequest addSubscriberRequest =
                          AddSubscriberRequest(
                              username: displayName,
                              postAuther: selectedUserName);
                      TrendingCubit.get(context)
                          .addSubscriber(addSubscriberRequest);
                    }
                  },
                  username: selectedUserName,
                  loggedInUserName: displayName,
                  loggedInUserImage: photoUrl,
                  statusBarHeight: statusBarHeight,
                  homePageModel: state.homePageModel,
                  userSubscribed: userSubscribed,
                ),
              );
            },
          );
        } else if (state is GetSuggestedUserPostsErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        } else if (state is AddPostSubscriberLoadingState) {
        } else if (state is AddPostSubscriberSuccessState) {
          TrendingCubit.get(context)
              .getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is AddPostSubscriberErrorState) {
          showSnackBar(context, state.errorMessage);
        } else if (state is DeletePostSubscriberLoadingState) {
        } else if (state is DeletePostSubscriberSuccessState) {
          TrendingCubit.get(context)
              .getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is DeletePostSubscriberErrorState) {
          showSnackBar(context, state.errorMessage);
        } else if (state is SendGeneralNotificationLoadingState) {
          showLoading();
        } else if (state is SendGeneralNotificationSuccessState) {
          hideLoading();
          setState(() {
            notificationType["active"] = false;
            notificationType["status"] = 0;
            notificationType["type"] = "";
            notificationType["postId"] = "";
          });
        } else if (state is SendGeneralNotificationErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
          setState(() {
            notificationType["active"] = false;
            notificationType["status"] = 0;
            notificationType["type"] = "";
            notificationType["postId"] = "";
          });
        } else if (state is TrendingNoInternetState) {
          hideLoading();
          onError(context, AppStrings.noInternet);
        }
      },
      builder: (context, state) {
        return trendingModel.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  suggestedUserModel.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.suggestedUsers,
                              style: AppTypography.kBold16
                                  .copyWith(color: AppColors.cSecondary),
                            ),
                            SizedBox(
                              height: AppConstants.heightBetweenElements,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 180.h,
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _scrollController2,
                                child: ListView.builder(
                                  controller: _scrollController2,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return SuggestedUserView(
                                      userImage:
                                          suggestedUserModel[index].userImage,
                                      userName:
                                          suggestedUserModel[index].userName,
                                      subscriptionsCount:
                                          suggestedUserModel[index]
                                              .subscriptionsCount,
                                      getUserPosts: (String userName) {
                                        setState(() {
                                          selectedUserName =
                                              suggestedUserModel[index].userName;
                                        });

                                        CheckIfUserSubscribedRequest
                                            checkIfUserSubscribedRequest =
                                            CheckIfUserSubscribedRequest(
                                                userName: displayName,
                                                postAuther:
                                                    suggestedUserModel[index]
                                                        .userName);
                                        TrendingCubit.get(context)
                                            .checkIfUserSubscribed(
                                                checkIfUserSubscribedRequest);
                                      },
                                    );
                                  },
                                  itemCount: suggestedUserModel.length,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  suggestedUserModel.isNotEmpty ? Divider() : Container(),
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  Text(
                    AppStrings.topPosts,
                    style: AppTypography.kBold16
                        .copyWith(color: AppColors.cSecondary),
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    color: AppColors.cTitle,
                    backgroundColor: AppColors.cWhite,
                    onRefresh: refresh,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PostView(
                            role: role,
                            addNewComment: (int status, String returnedId) {
                              setState(() {
                                selectedId = returnedId;
                                showCommentBottomSheet = true;
                                notificationType["active"] = true;
                                notificationType["status"] = status;
                                notificationType["type"] = "comment";
                                notificationType["postId"] = homePageModel[index].postModel.id!;
                              });
                              if (status == 1) {
                                AddPostSubscriberRequest
                                    addPostSubscriberRequest =
                                    AddPostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  userEmail: email,
                                  postId: trendingModel[index].postModel.id!,
                                ));
                                TrendingCubit.get(context)
                                    .addPostSubscriber(addPostSubscriberRequest);
                              } else if (status == -1) {
                                DeletePostSubscriberRequest
                                    deletePostSubscriberRequest =
                                    DeletePostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  userEmail: email,
                                  postId: trendingModel[index].postModel.id!,
                                ));
                                TrendingCubit.get(context).deletePostSubscriber(
                                    deletePostSubscriberRequest);
                              } else if (status == 0) {
                                TrendingCubit.get(context).getTopPosts(
                                    GetTopPostsRequest(currentUser: displayName));
                              }
                            },
                            addNewEmoji: (int status) {
                              setState(() {
                                notificationType["active"] = true;
                                notificationType["status"] = status;
                                notificationType["type"] = "emoji";
                                notificationType["postId"] = homePageModel[index].postModel.id!;
                              });
                              if (status == 1) {
                                AddPostSubscriberRequest
                                    addPostSubscriberRequest =
                                    AddPostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  userEmail: email,
                                  postId: trendingModel[index].postModel.id!,
                                ));
                                TrendingCubit.get(context)
                                    .addPostSubscriber(addPostSubscriberRequest);
                              } else if (status == -1) {
                                DeletePostSubscriberRequest
                                    deletePostSubscriberRequest =
                                    DeletePostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  userEmail: email,
                                  postId: trendingModel[index].postModel.id!,
                                ));
                                TrendingCubit.get(context).deletePostSubscriber(
                                    deletePostSubscriberRequest);
                              } else if (status == 0) {
                                TrendingCubit.get(context).getTopPosts(
                                    GetTopPostsRequest(currentUser: displayName));
                              }
                            },
                            postUpdated: () {
                              TrendingCubit.get(context).getTopPosts(
                                  GetTopPostsRequest(currentUser: displayName));
                            },
                            loggedInUserEmail: email,
                            postUserEmail: trendingModel[index]
                                .postModel
                                .userEmail,
                            postSubscribersList: trendingModel[index]
                                .postModel
                                .postSubscribersList,
                            getUserPosts: (String userName) {
                              Navigator.pushNamed(context, Routes.userPostsRoute,
                                  arguments: UserPostsArguments(
                                      username: userName,
                                      reload: () {
                                        getTopPosts(displayName);
                                        getSuggestedUsers();
                                      }));
                            },
                            addOrRemoveSubscriber: (int status) {
                              if (status == -1) {
                                DeleteSubscriberRequest deleteSubscriberRequest =
                                    DeleteSubscriberRequest(
                                        username: displayName,
                                        postAuther: trendingModel[index]
                                            .postModel
                                            .username);
                                TrendingCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                    AddSubscriberRequest(
                                        username: displayName,
                                        postAuther: trendingModel[index]
                                            .postModel
                                            .username);
                                TrendingCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              }
                            },
                            index: index,
                            id: trendingModel[index].postModel.id!,
                            time: trendingModel[index].postModel.time!,
                            postUsername: trendingModel[index].postModel.username,
                            postUserImage:
                                trendingModel[index].postModel.userImage,
                            loggedInUserName: displayName,
                            loggedInUserImage: photoUrl,
                            postAlsha: trendingModel[index].postModel.postAlsha,
                            commentsList:
                                trendingModel[index].postModel.commentsList,
                            emojisList: trendingModel[index].postModel.emojisList,
                            statusBarHeight: statusBarHeight,
                            userSubscribed: trendingModel[index].userSubscribed,
                          );
                        },
                        itemCount: trendingModel.length,
                      ),
                    ),
                  ))
                ],
              )
            : SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        AppStrings.noPosts,
                        style: AppTypography.kBold12,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
