import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:last/core/utils/constant/app_assets.dart';
import 'package:last/features/notifications/data/model/requests/get_post_data_request.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/preferences/secure_local_data.dart';
import '../../../../../core/router/arguments.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../../core/utils/ui_components/snackbar.dart';
import '../../../../home_page/data/model/home_page_model.dart';
import '../../../../home_page/data/model/post_subscribers_model.dart';
import '../../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../../home_page/data/model/requests/send_notification_request.dart';
import '../../../../home_page/data/model/subscribers_model.dart';
import '../../../../home_page/presentation/bloc/home_page_cubit.dart';
import '../../../../home_page/presentation/bloc/home_page_state.dart';
import '../../../../home_page/presentation/ui/widgets/comments_bottom_sheet.dart';
import '../../../../home_page/presentation/ui/widgets/post_view.dart';
import 'dart:ui' as ui;

class PostDataView extends StatefulWidget {
  PostDataArguments arguments;
  PostDataView({super.key, required this.arguments});

  @override
  State<PostDataView> createState() => _PostDataViewState();
}

class _PostDataViewState extends State<PostDataView> {
  int selectedPost = 0;
  String selectedId = "";
  bool showCommentBottomSheet = false;
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

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

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
      role = userData['role'] ?? '';
    });
    getPostData();
  }

  getPostData() {
    HomePageCubit.get(context).getPostData(GetPostDataRequest(
        postId: widget.arguments.postId!,username: widget.arguments.username!));
  }

  Future<void> refresh() async {
    setState(() {
      getPostData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
            body: bodyContent(context, statusBarHeight),
          )),
    );
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return Column(
      children: [
        SizedBox(height: AppConstants.moreHeightBetweenElements),
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              AppAssets.back,
              width: 30.w,
            )),
        SizedBox(height: AppConstants.moreHeightBetweenElements),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: BlocConsumer<HomePageCubit, HomePageState>(
              listener: (context, state) async {
                if (state is GetPostDataLoadingState) {
                  showLoading();
                } else if (state is GetPostDataSuccessState) {
                  hideLoading();
                  notificationPostData.clear();
                  notificationPostData.addAll(state.homePageModel);
                  selectedPost = notificationPostData.indexWhere(
                          (element) => element.postModel.id == selectedId);
                  if (showCommentBottomSheet &&
                      notificationPostData[selectedPost]
                          .postModel
                          .commentsList
                          .isNotEmpty) {
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
                            getUserPosts: (String userName) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!));
                            },
                            userEmail: email,
                            addOrRemoveSubscriber: (int status) {
                              if (status == -1) {
                                DeleteSubscriberRequest
                                deleteSubscriberRequest =
                                DeleteSubscriberRequest(
                                    username: displayName,
                                    postAuther: notificationPostData[selectedPost]
                                        .postModel
                                        .username);
                                HomePageCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                AddSubscriberRequest(
                                    username: displayName,
                                    postAuther: notificationPostData[selectedPost]
                                        .postModel
                                        .username);
                                HomePageCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              }
                            },
                            postId: notificationPostData[selectedPost]
                                .postModel
                                .commentsList[0]
                                .postId,
                            userName: displayName,
                            userImage: photoUrl,
                            addNewComment: (int status, String returnedId) {
                              setState(() {
                                selectedId = returnedId;
                                showCommentBottomSheet = true;
                                notificationType["active"] = true;
                                notificationType["status"] = status;
                                notificationType["type"] = "comment";
                                notificationType["postId"] = notificationPostData[selectedPost].postModel.id!;
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
                                      postId:
                                      notificationPostData[selectedPost].postModel.id!,
                                    ));
                                HomePageCubit.get(context).addPostSubscriber(
                                    addPostSubscriberRequest);
                              } else if (status == -1) {
                                DeletePostSubscriberRequest
                                deletePostSubscriberRequest =
                                DeletePostSubscriberRequest(
                                    postSubscribersModel:
                                    PostSubscribersModel(
                                      username: displayName,
                                      userImage: photoUrl,
                                      userEmail: email,
                                      postId:
                                      notificationPostData[selectedPost].postModel.id!,
                                    ));
                                HomePageCubit.get(context).deletePostSubscriber(
                                    deletePostSubscriberRequest);
                              } else if (status == 0) {
                                HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                    postId: widget.arguments.postId!,username: widget.arguments.username!));
                              }
                            },
                            statusBarHeight: statusBarHeight,
                            commentsList: notificationPostData[selectedPost]
                                .postModel
                                .commentsList,
                            postAlsha:
                            notificationPostData[selectedPost].postModel.postAlsha,
                          ),
                        );
                      },
                    );
                    setState(() {
                      showCommentBottomSheet = false;
                    });
                  }
                } else if (state is GetPostDataErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is AddSubscriberLoadingState) {
                  showLoading();
                } else if (state is AddSubscriberSuccessState) {
                  hideLoading();
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!));
                } else if (state is AddSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeleteSubscriberLoadingState) {
                  showLoading();
                } else if (state is DeleteSubscriberSuccessState) {
                  hideLoading();
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!));
                } else if (state is DeleteSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is AddPostSubscriberLoadingState) {
                } else if (state is AddPostSubscriberSuccessState) {
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!));
                } else if (state is AddPostSubscriberErrorState) {
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeletePostSubscriberLoadingState) {
                } else if (state is DeletePostSubscriberSuccessState) {
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!));
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
                  setState(() {
                    notificationType["active"] = false;
                    notificationType["status"] = 0;
                    notificationType["type"] = "";
                    notificationType["postId"] = "";
                  });
                  showSnackBar(context, state.errorMessage);
                } else if (state is HomePageNoInternetState) {
                  hideLoading();
                  onError(context, AppStrings.noInternet);
                }
              },
              builder: (context, state) {
                return notificationPostData.isNotEmpty
                    ? RefreshIndicator(
                  color: AppColors.cTitle,
                  backgroundColor: AppColors.cWhite,
                  onRefresh: refresh,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PostView(
                          getUserPosts: (String userName) {},
                          addOrRemoveSubscriber: (int status) {
                            if (status == -1) {
                              DeleteSubscriberRequest
                              deleteSubscriberRequest =
                              DeleteSubscriberRequest(
                                  username: displayName,
                                  postAuther: notificationPostData[index]
                                      .postModel
                                      .username);
                              HomePageCubit.get(context).deleteSubscriber(
                                  deleteSubscriberRequest);
                            } else if (status == 1) {
                              AddSubscriberRequest addSubscriberRequest =
                              AddSubscriberRequest(
                                  username: displayName,
                                  postAuther: notificationPostData[index]
                                      .postModel
                                      .username);
                              HomePageCubit.get(context)
                                  .addSubscriber(addSubscriberRequest);
                            }
                          },
                          index: index,
                          id: notificationPostData[index].postModel.id!,
                          time: notificationPostData[index].postModel.time!,
                          postUsername:
                          notificationPostData[index].postModel.username,
                          postUserImage:
                          notificationPostData[index].postModel.userImage,
                          postUserEmail:
                          notificationPostData[index].postModel.userEmail,
                          loggedInUserName: displayName,
                          loggedInUserImage: photoUrl,
                          loggedInUserEmail: email,
                          postAlsha:
                          notificationPostData[index].postModel.postAlsha,
                          commentsList:
                          notificationPostData[index].postModel.commentsList,
                          emojisList:
                          notificationPostData[index].postModel.emojisList,
                          addNewComment: (int status, String returnedId) {
                            setState(() {
                              selectedId = returnedId;
                              showCommentBottomSheet = true;
                              notificationType["active"] = true;
                              notificationType["status"] = status;
                              notificationType["type"] = "comment";
                              notificationType["postId"] = notificationPostData[index].postModel.id!;
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
                                    postId:
                                    notificationPostData[index].postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .addPostSubscriber(
                                  addPostSubscriberRequest);
                            } else if (status == -1) {
                              DeletePostSubscriberRequest
                              deletePostSubscriberRequest =
                              DeletePostSubscriberRequest(
                                  postSubscribersModel:
                                  PostSubscribersModel(
                                    username: displayName,
                                    userImage: photoUrl,
                                    userEmail: email,
                                    postId:
                                    notificationPostData[index].postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .deletePostSubscriber(
                                  deletePostSubscriberRequest);
                            } else if (status == 0) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!));
                            }
                          },
                          addNewEmoji: (int status) {
                            setState(() {
                              notificationType["active"] = true;
                              notificationType["status"] = status;
                              notificationType["type"] = "emoji";
                              notificationType["postId"] = notificationPostData[index].postModel.id!;
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
                                    postId:
                                    notificationPostData[index].postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .addPostSubscriber(
                                  addPostSubscriberRequest);
                            } else if (status == -1) {
                              DeletePostSubscriberRequest
                              deletePostSubscriberRequest =
                              DeletePostSubscriberRequest(
                                  postSubscribersModel:
                                  PostSubscribersModel(
                                    username: displayName,
                                    userImage: photoUrl,
                                    userEmail: email,
                                    postId:
                                    notificationPostData[index].postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .deletePostSubscriber(
                                  deletePostSubscriberRequest);
                            } else if (status == 0) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!));
                            }
                          },
                          statusBarHeight: statusBarHeight,
                          postUpdated: () {
                            HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                postId: widget.arguments.postId!,username: widget.arguments.username!));
                          },
                          userSubscribed:
                          notificationPostData[index].userSubscribed,
                          postSubscribersList: notificationPostData[index]
                              .postModel
                              .postSubscribersList,
                        );
                      },
                      itemCount: notificationPostData.length),
                )
                    : SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          AppStrings.noPostFound,
                          style: AppTypography.kBold12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
