import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/core/utils/constant/app_typography.dart';
import 'package:last/core/utils/ui_components/primary_button.dart';
import 'package:last/features/home_page/data/model/home_page_model.dart';
import 'package:last/features/home_page/presentation/bloc/home_page_cubit.dart';
import 'package:last/features/home_page/presentation/ui/widgets/comments_bottom_sheet.dart';
import 'package:last/features/home_page/presentation/ui/widgets/post_view.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../data/model/requests/add_post_subscriber_request.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_post_subscriber_request.dart';
import '../../data/model/post_subscribers_model.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/requests/get_posts_request.dart';
import '../../data/model/subscribers_model.dart';
import '../bloc/home_page_state.dart';

class HomeView extends StatefulWidget {
  bool searching;
  Function showAllAgain;
  HomeView({super.key, required this.searching, required this.showAllAgain});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedPost = 0;
  bool showCommentBottomSheet = false;
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  final TextEditingController _searchingController = TextEditingController();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  List<SubscribersModel> subscribersList = [];
  bool showAll = true;
  var userData;

  Future<void> refresh() async {
    setState(() {
      if (!showAll) {
        HomePageCubit.get(context).getAllPosts(GetPostsRequest(
            currentUser: displayName,
            allPosts: false,
            username: homePageModel[selectedPost].postModel.username));
      } else {
        HomePageCubit.get(context).getAllPosts(
            GetPostsRequest(currentUser: displayName, allPosts: true));
      }
    });
  }

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
    });
    getAllPosts(displayName, allPosts: true);
  }

  getAllPosts(String displayName, {bool? allPosts, String? username}) {
    HomePageCubit.get(context)
        .getAllPosts(GetPostsRequest(currentUser: displayName, allPosts: true));
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
    return Column(
      children: [
        showAll
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  PrimaryButton(
                    onTap: () {
                      setState(() {
                        showAll = true;
                      });
                      HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                          currentUser: displayName, allPosts: true));
                    },
                    text: AppStrings.showAll,
                    width: 120.w,
                    gradient: false,
                    fontSize: 18.sp,
                    height: 50.h,
                  ),
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                ],
              ),
        widget.searching
            ? Column(
                children: [
                  SizedBox(
                    height: AppConstants.moreHeightBetweenElements,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.60,
                        child: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            controller: _searchingController,
                            decoration: InputDecoration(
                                suffixIcon: Bounceable(
                                    onTap: () {
                                      setState(() {
                                        widget.searching = false;
                                        _searchingController.text = "";
                                      });
                                      widget.showAllAgain();
                                    },
                                    child: Icon(Icons.close,
                                        color: AppColors.cBlack, size: 20.sp)),
                                contentPadding: EdgeInsets.all(15.w),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.cSecondary),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radius),
                                ),
                                labelText: AppStrings.searchForPost,
                                border: InputBorder.none)),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      BlocConsumer<HomePageCubit, HomePageState>(
                        listener: (context, state) async {
                          if (state is SearchPostLoadingState) {
                            showLoading();
                          } else if (state is SearchPostSuccessState) {
                            hideLoading();
                            homePageModel.clear();
                            homePageModel.addAll(state.homePageModel);
                          } else if (state is SearchPostErrorState) {
                            hideLoading();
                            showSnackBar(context, state.errorMessage);
                          } else if (state is HomePageNoInternetState) {
                            hideLoading();
                            onError(context, AppStrings.noInternet);
                          }
                        },
                        builder: (context, state) {
                          return PrimaryButton(
                            onTap: () {
                              HomePageCubit.get(context)
                                  .searchPost(_searchingController.text.trim());
                            },
                            text: AppStrings.search,
                            width: 100.w,
                            gradient: true,
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  )
                ],
              )
            : Container(),
        Expanded(
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
                            setState(() {
                              showAll = false;
                            });
                            HomePageCubit.get(context).getAllPosts(
                                GetPostsRequest(
                                    currentUser: displayName,
                                    allPosts: false,
                                    username: homePageModel[selectedPost]
                                        .postModel
                                        .username));
                          },
                          addOrRemoveSubscriber: (int status) {
                            if (status == -1) {
                              DeleteSubscriberRequest deleteSubscriberRequest =
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
                              HomePageCubit.get(context)
                                  .addPostSubscriber(addPostSubscriberRequest);
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
                              if (!showAll) {
                                HomePageCubit.get(context).getAllPosts(
                                    GetPostsRequest(
                                        currentUser: displayName,
                                        allPosts: false,
                                        username: homePageModel[selectedPost]
                                            .postModel
                                            .username));
                              } else {
                                HomePageCubit.get(context).getAllPosts(
                                    GetPostsRequest(
                                        currentUser: displayName,
                                        allPosts: true));
                              }
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
                if (!showAll) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username:
                          homePageModel[selectedPost].postModel.username));
                } else {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName, allPosts: true));
                }
              } else if (state is AddSubscriberErrorState) {
                hideLoading();
                showSnackBar(context, state.errorMessage);
              } else if (state is DeleteSubscriberLoadingState) {
                showLoading();
              } else if (state is DeleteSubscriberSuccessState) {
                hideLoading();
                if (!showAll) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username:
                          homePageModel[selectedPost].postModel.username));
                } else {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName, allPosts: true));
                }
              } else if (state is DeleteSubscriberErrorState) {
                hideLoading();
                showSnackBar(context, state.errorMessage);
              } else if (state is AddPostSubscriberLoadingState) {
              } else if (state is AddPostSubscriberSuccessState) {
                if (!showAll) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username:
                          homePageModel[selectedPost].postModel.username));
                } else {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName, allPosts: true));
                }
              } else if (state is AddPostSubscriberErrorState) {
                showSnackBar(context, state.errorMessage);
              } else if (state is DeletePostSubscriberLoadingState) {
              } else if (state is DeletePostSubscriberSuccessState) {
                if (!showAll) {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName,
                      allPosts: false,
                      username:
                          homePageModel[selectedPost].postModel.username));
                } else {
                  HomePageCubit.get(context).getAllPosts(GetPostsRequest(
                      currentUser: displayName, allPosts: true));
                }
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
                                setState(() {
                                  showAll = false;
                                });
                                HomePageCubit.get(context).getAllPosts(
                                    GetPostsRequest(
                                        currentUser: displayName,
                                        allPosts: false,
                                        username: homePageModel[index]
                                            .postModel
                                            .username));
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
                                setState(() {
                                  selectedPost = index;
                                });
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
                                    postId: homePageModel[index].postModel.id!,
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
                                    postId: homePageModel[index].postModel.id!,
                                  ));
                                  HomePageCubit.get(context)
                                      .deletePostSubscriber(
                                          deletePostSubscriberRequest);
                                } else if (status == 0) {
                                  if (!showAll) {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: false,
                                            username: homePageModel[index]
                                                .postModel
                                                .username));
                                  } else {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: true));
                                  }
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
                                    postId: homePageModel[index].postModel.id!,
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
                                    postId: homePageModel[index].postModel.id!,
                                  ));
                                  HomePageCubit.get(context)
                                      .deletePostSubscriber(
                                          deletePostSubscriberRequest);
                                } else if (status == 0) {
                                  if (!showAll) {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: false,
                                            username: homePageModel[index]
                                                .postModel
                                                .username));
                                  } else {
                                    HomePageCubit.get(context).getAllPosts(
                                        GetPostsRequest(
                                            currentUser: displayName,
                                            allPosts: true));
                                  }
                                }
                              },
                              statusBarHeight: statusBarHeight,
                              postUpdated: () {
                                if (!showAll) {
                                  HomePageCubit.get(context).getAllPosts(
                                      GetPostsRequest(
                                          currentUser: displayName,
                                          allPosts: false,
                                          username: homePageModel[index]
                                              .postModel
                                              .username));
                                } else {
                                  HomePageCubit.get(context).getAllPosts(
                                      GetPostsRequest(
                                          currentUser: displayName,
                                          allPosts: true));
                                }
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
        )
      ],
    );
  }
}
