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
        postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
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
                  notificationPostData = state.homePageModel;
                  selectedPost = 0;
                  if (showCommentBottomSheet &&
                      notificationPostData!
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
                            role: role,
                            getUserPosts: (String userName) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                            },
                            userEmail: email,
                            addOrRemoveSubscriber: (int status) {
                              if (status == -1) {
                                DeleteSubscriberRequest
                                deleteSubscriberRequest =
                                DeleteSubscriberRequest(
                                    username: displayName,
                                    postAuther: notificationPostData!
                                        .postModel
                                        .username);
                                HomePageCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                AddSubscriberRequest(
                                    username: displayName,
                                    postAuther: notificationPostData!
                                        .postModel
                                        .username);
                                HomePageCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              }
                            },
                            postId: notificationPostData!
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
                                notificationType["postId"] = notificationPostData!.postModel.id!;
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
                                      notificationPostData!.postModel.id!,
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
                                      notificationPostData!.postModel.id!,
                                    ));
                                HomePageCubit.get(context).deletePostSubscriber(
                                    deletePostSubscriberRequest);
                              } else if (status == 0) {
                                HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                    postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                              }
                            },
                            statusBarHeight: statusBarHeight,
                            commentsList: notificationPostData!
                                .postModel
                                .commentsList,
                            postAlsha:
                            notificationPostData!.postModel.postAlsha,
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
                      postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                } else if (state is AddSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeleteSubscriberLoadingState) {
                  showLoading();
                } else if (state is DeleteSubscriberSuccessState) {
                  hideLoading();
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                } else if (state is DeleteSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is AddPostSubscriberLoadingState) {
                } else if (state is AddPostSubscriberSuccessState) {
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                } else if (state is AddPostSubscriberErrorState) {
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeletePostSubscriberLoadingState) {
                } else if (state is DeletePostSubscriberSuccessState) {
                  HomePageCubit.get(context).getPostData(GetPostDataRequest(
                      postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
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
                return notificationPostData != null
                    ? RefreshIndicator(
                  color: AppColors.cTitle,
                  backgroundColor: AppColors.cWhite,
                  onRefresh: refresh,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PostView(
                          role: role,
                          getUserPosts: (String userName) {},
                          addOrRemoveSubscriber: (int status) {
                            if (status == -1) {
                              DeleteSubscriberRequest
                              deleteSubscriberRequest =
                              DeleteSubscriberRequest(
                                  username: displayName,
                                  postAuther: notificationPostData!
                                      .postModel
                                      .username);
                              HomePageCubit.get(context).deleteSubscriber(
                                  deleteSubscriberRequest);
                            } else if (status == 1) {
                              AddSubscriberRequest addSubscriberRequest =
                              AddSubscriberRequest(
                                  username: displayName,
                                  postAuther: notificationPostData!
                                      .postModel
                                      .username);
                              HomePageCubit.get(context)
                                  .addSubscriber(addSubscriberRequest);
                            }
                          },
                          index: index,
                          id: notificationPostData!.postModel.id!,
                          time: notificationPostData!.postModel.time!,
                          postUsername:
                          notificationPostData!.postModel.username,
                          postUserImage:
                          notificationPostData!.postModel.userImage,
                          postUserEmail:
                          notificationPostData!.postModel.userEmail,
                          loggedInUserName: displayName,
                          loggedInUserImage: photoUrl,
                          loggedInUserEmail: email,
                          postAlsha:
                          notificationPostData!.postModel.postAlsha,
                          commentsList:
                          notificationPostData!.postModel.commentsList,
                          emojisList:
                          notificationPostData!.postModel.emojisList,
                          addNewComment: (int status, String returnedId) {
                            setState(() {
                              selectedId = returnedId;
                              showCommentBottomSheet = true;
                              notificationType["active"] = true;
                              notificationType["status"] = status;
                              notificationType["type"] = "comment";
                              notificationType["postId"] = notificationPostData!.postModel.id!;
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
                                    notificationPostData!.postModel.id!,
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
                                    notificationPostData!.postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .deletePostSubscriber(
                                  deletePostSubscriberRequest);
                            } else if (status == 0) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                            }
                          },
                          addNewEmoji: (int status) {
                            setState(() {
                              notificationType["active"] = true;
                              notificationType["status"] = status;
                              notificationType["type"] = "emoji";
                              notificationType["postId"] = notificationPostData!.postModel.id!;
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
                                    notificationPostData!.postModel.id!,
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
                                    notificationPostData!.postModel.id!,
                                  ));
                              HomePageCubit.get(context)
                                  .deletePostSubscriber(
                                  deletePostSubscriberRequest);
                            } else if (status == 0) {
                              HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                  postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                            }
                          },
                          statusBarHeight: statusBarHeight,
                          postUpdated: () {
                            HomePageCubit.get(context).getPostData(GetPostDataRequest(
                                postId: widget.arguments.postId!,username: widget.arguments.username!,postAuther: widget.arguments.postAuther!));
                          },
                          userSubscribed:
                          notificationPostData!.userSubscribed,
                          postSubscribersList: notificationPostData!
                              .postModel
                              .postSubscribersList,
                        );
                      },
                      itemCount: 1),
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
