import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:last/core/utils/constant/app_assets.dart';
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
import '../../../../home_page/data/model/subscribers_model.dart';
import '../../../../home_page/presentation/bloc/home_page_cubit.dart';
import '../../../../home_page/presentation/bloc/home_page_state.dart';
import '../../../../home_page/presentation/ui/widgets/comments_bottom_sheet.dart';
import '../../../../home_page/presentation/ui/widgets/post_view.dart';

class UserPostsView extends StatefulWidget {
  UserPostsArguments arguments;
  UserPostsView({super.key, required this.arguments});

  @override
  State<UserPostsView> createState() => _UserPostsViewState();
}

class _UserPostsViewState extends State<UserPostsView> {
  int selectedPost = 0;
  bool showCommentBottomSheet = false;
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  final TextEditingController _searchingController = TextEditingController();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  String role = "";
  String enableAdd = "";

  List<SubscribersModel> subscribersList = [];
  var userData;
  

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
    getUserPosts(displayName, allPosts: true);
  }

  getUserPosts(String displayName, {bool? allPosts, String? username}) {
    HomePageCubit.get(context).getAllPosts(GetPostsRequest(
        currentUser: displayName,
        allPosts: false,
        username: widget.arguments.username));
  }

  Future<void> refresh() async {
    setState(() {
      getUserPosts(displayName, allPosts: true);
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
              widget.arguments.reload!();
            },
            child: SvgPicture.asset(
              AppAssets.back,
              width: 30.w,
            )),
        SizedBox(height: AppConstants.moreHeightBetweenElements),
        Center(
          child: Text(
            AppStrings.userSubscriptions,
            style: AppTypography.kBold24.copyWith(color: AppColors.cTitle),
          ),
        ),
        Center(
          child: Flexible(
            child: Text(
              widget.arguments.username!,
              style: AppTypography.kBold18.copyWith(color: AppColors.cTitle),
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: BlocConsumer<HomePageCubit, HomePageState>(
              listener: (context, state) async {
                if (state is GetAllPostsLoadingState) {
                  showLoading();
                } else if (state is GetAllPostsSuccessState) {
                  hideLoading();
                  homePageModel.clear();
                  homePageModel.addAll(state.homePageModel);
                  if (showCommentBottomSheet &&
                      homePageModel[selectedPost]
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
                          textDirection: TextDirection.rtl,
                          child: CommentsBottomSheet(
                            getUserPosts: () {
                              HomePageCubit.get(context).getAllPosts(
                                  GetPostsRequest(
                                      currentUser: displayName,
                                      allPosts: false,
                                      username: widget.arguments.username));
                            },
                            addOrRemoveSubscriber: (int status) {
                              if (status == -1) {
                                DeleteSubscriberRequest
                                    deleteSubscriberRequest =
                                    DeleteSubscriberRequest(
                                        username: displayName,
                                        postAuther: homePageModel[selectedPost]
                                            .postModel
                                            .username);
                                HomePageCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                    AddSubscriberRequest(
                                        username: displayName,
                                        postAuther: homePageModel[selectedPost]
                                            .postModel
                                            .username);
                                HomePageCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              }
                            },
                            postId: homePageModel[selectedPost]
                                .postModel
                                .commentsList[0]
                                .postId,
                            userName: displayName,
                            userImage: photoUrl,
                            addNewComment: (int status) {
                              if (status == 1) {
                                AddPostSubscriberRequest
                                    addPostSubscriberRequest =
                                    AddPostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  postId:
                                      homePageModel[selectedPost].postModel.id!,
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
                                  postId:
                                      homePageModel[selectedPost].postModel.id!,
                                ));
                                HomePageCubit.get(context).deletePostSubscriber(
                                    deletePostSubscriberRequest);
                              } else if (status == 0) {
                                HomePageCubit.get(context).getAllPosts(
                                    GetPostsRequest(
                                        currentUser: displayName,
                                        allPosts: false,
                                        username: widget.arguments.username));
                              }
                              setState(() {
                                showCommentBottomSheet = true;
                              });
                            },
                            statusBarHeight: statusBarHeight,
                            commentsList: homePageModel[selectedPost]
                                .postModel
                                .commentsList,
                            postAlsha:
                                homePageModel[selectedPost].postModel.postAlsha,
                          ),
                        );
                      },
                    );
                    setState(() {
                      showCommentBottomSheet = false;
                    });
                  }
                } else if (state is GetAllPostsErrorState) {
                  showSnackBar(context, state.errorMessage);
                  hideLoading();
                } else if (state is AddSubscriberLoadingState) {
                  showLoading();
                } else if (state is AddSubscriberSuccessState) {
                  hideLoading();
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username: widget.arguments.username));
                } else if (state is AddSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeleteSubscriberLoadingState) {
                  showLoading();
                } else if (state is DeleteSubscriberSuccessState) {
                  hideLoading();
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username: widget.arguments.username));
                } else if (state is DeleteSubscriberErrorState) {
                  hideLoading();
                  showSnackBar(context, state.errorMessage);
                } else if (state is AddPostSubscriberLoadingState) {
                } else if (state is AddPostSubscriberSuccessState) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username: widget.arguments.username));
                } else if (state is AddPostSubscriberErrorState) {
                  showSnackBar(context, state.errorMessage);
                } else if (state is DeletePostSubscriberLoadingState) {
                } else if (state is DeletePostSubscriberSuccessState) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username: widget.arguments.username));
                } else if (state is DeletePostSubscriberErrorState) {
                  showSnackBar(context, state.errorMessage);
                } else if (state is HomePageNoInternetState) {
                  hideLoading();
                  onError(context, AppStrings.noInternet);
                }
              },
              builder: (context, state) {
                return homePageModel.isNotEmpty
                    ? RefreshIndicator(
                        color: AppColors.cTitle,
                        backgroundColor: AppColors.cWhite,
                        onRefresh: refresh,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return PostView(
                                getUserPosts: () {
                                  HomePageCubit.get(context).getAllPosts(
                                      GetPostsRequest(
                                          currentUser: displayName,
                                          allPosts: false,
                                          username: widget.arguments.username));
                                },
                                addOrRemoveSubscriber: (int status) {
                                  if (status == -1) {
                                    DeleteSubscriberRequest
                                        deleteSubscriberRequest =
                                        DeleteSubscriberRequest(
                                            username: displayName,
                                            postAuther: homePageModel[index]
                                                .postModel
                                                .username);
                                    HomePageCubit.get(context).deleteSubscriber(
                                        deleteSubscriberRequest);
                                  } else if (status == 1) {
                                    AddSubscriberRequest addSubscriberRequest =
                                        AddSubscriberRequest(
                                            username: displayName,
                                            postAuther: homePageModel[index]
                                                .postModel
                                                .username);
                                    HomePageCubit.get(context)
                                        .addSubscriber(addSubscriberRequest);
                                  }
                                },
                                index: index,
                                id: homePageModel[index].postModel.id!,
                                time: homePageModel[index].postModel.time!,
                                postUsername:
                                    homePageModel[index].postModel.username,
                                postUserImage:
                                    homePageModel[index].postModel.userImage,
                                loggedInUserName: displayName,
                                loggedInUserImage: photoUrl,
                                postAlsha:
                                    homePageModel[index].postModel.postAlsha,
                                commentsList:
                                    homePageModel[index].postModel.commentsList,
                                emojisList:
                                    homePageModel[index].postModel.emojisList,
                                addNewComment: (int status) {
                                  if (status == 1) {
                                    AddPostSubscriberRequest
                                        addPostSubscriberRequest =
                                        AddPostSubscriberRequest(
                                            postSubscribersModel:
                                                PostSubscribersModel(
                                      username: displayName,
                                      userImage: photoUrl,
                                      postId:
                                          homePageModel[index].postModel.id!,
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
                                      postId:
                                          homePageModel[index].postModel.id!,
                                    ));
                                    HomePageCubit.get(context)
                                        .deletePostSubscriber(
                                            deletePostSubscriberRequest);
                                  } else if (status == 0) {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: false,
                                            username:
                                                widget.arguments.username));
                                  }

                                  setState(() {
                                    selectedPost = index;
                                    showCommentBottomSheet = true;
                                  });
                                },
                                addNewEmoji: (int status) {
                                  if (status == 1) {
                                    AddPostSubscriberRequest
                                        addPostSubscriberRequest =
                                        AddPostSubscriberRequest(
                                            postSubscribersModel:
                                                PostSubscribersModel(
                                      username: displayName,
                                      userImage: photoUrl,
                                      postId:
                                          homePageModel[index].postModel.id!,
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
                                      postId:
                                          homePageModel[index].postModel.id!,
                                    ));
                                    HomePageCubit.get(context)
                                        .deletePostSubscriber(
                                            deletePostSubscriberRequest);
                                  } else if (status == 0) {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: false,
                                            username:
                                                widget.arguments.username));
                                  }
                                },
                                statusBarHeight: statusBarHeight,
                                postUpdated: () {
                                  HomePageCubit.get(context).getAllPosts(
                                      GetPostsRequest(
                                          currentUser: displayName,
                                          allPosts: false,
                                          username: widget.arguments.username));
                                },
                                userSubscribed:
                                    homePageModel[index].userSubscribed,
                                postSubscribersList: homePageModel[index]
                                    .postModel
                                    .postSubscribersList,
                              );
                            },
                            itemCount: homePageModel.length),
                      )
                    : SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                AppStrings.noPosts,
                                style: AppTypography.kBold14,
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
