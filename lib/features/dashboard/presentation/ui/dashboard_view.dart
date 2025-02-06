import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/core/utils/constant/app_typography.dart';
import 'package:last/core/utils/dialogs/error_dialog.dart';
import 'package:last/core/utils/style/app_colors.dart';
import 'package:last/core/utils/ui_components/loading_dialog.dart';
import 'package:last/core/utils/ui_components/snackbar.dart';
import 'package:last/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:last/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:last/features/dashboard/presentation/ui/widgets/advice_view.dart';
import 'package:last/features/dashboard/presentation/ui/widgets/dashboard_post_view.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_subscribers_model.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../layout/data/model/advice_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool lastPosts = true;
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  String role = "";

  var userData;
  

  @override
  void initState() {
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    super.initState();
  }

  Future<void> refreshLastPosts() async {
    setState(() {
      DashboardCubit.get(context).getAllPosts(
          GetPostsRequest(currentUser: displayName, allPosts: true));
    });
  }

  Future<void> refreshAdvices() async {
    setState(() {
      DashboardCubit.get(context).getUserAdvices();
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
    getAllPosts(displayName, allPosts: true);
    getUserAdvices();
  }

  getAllPosts(String displayName, {bool? allPosts, String? username}) {
    DashboardCubit.get(context)
        .getAllPosts(GetPostsRequest(currentUser: displayName, allPosts: true));
  }

  getUserAdvices() {
    DashboardCubit.get(context).getUserAdvices();
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
        Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!lastPosts) {
                      setState(() {
                        lastPosts = !lastPosts;
                      });
                    }
                  },
                  child: Container(
                    height: 70.h,
                    width: (MediaQuery.sizeOf(context).width / 2) - 15.w,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color:
                          lastPosts ? AppColors.cTitle : AppColors.cTransparent,
                      width: 5,
                    ))),
                    child: Center(
                      child: Text(
                        AppStrings.lastPosts,
                        style: AppTypography.kBold18,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 45.h,
                  width: 1.5.w,
                  color: AppColors.cTitle,
                ),
                GestureDetector(
                  onTap: () {
                    if (lastPosts) {
                      setState(() {
                        lastPosts = !lastPosts;
                      });
                    }
                  },
                  child: Container(
                    height: 70.h,
                    width: (MediaQuery.sizeOf(context).width / 2) - 15.w,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.cTransparent,
                        border: Border(
                            bottom: BorderSide(
                          color: lastPosts
                              ? AppColors.cTransparent
                              : AppColors.cTitle,
                          width: 5,
                        ))),
                    child: Center(
                      child: Text(
                        AppStrings.suggestions,
                        style: AppTypography.kBold18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                width: MediaQuery.sizeOf(context).width - 10.w,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: AppColors.cTitle,
                  width: 1,
                ))))
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        lastPosts
            ? Expanded(
                child: BlocConsumer<DashboardCubit, DashboardState>(
                  listener: (context, state) {
                    if (state is GetAllPostsLoadingState) {
                      showLoading();
                    } else if (state is GetAllPostsSuccessState) {
                      hideLoading();
                      homePageModel.clear();
                      homePageModel.addAll(state.homePageModel);
                    } else if (state is GetAllPostsErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                    } else if (state is GetUserAdvicesLoadingState) {
                      showLoading();
                    } else if (state is GetUserAdvicesSuccessState) {
                      hideLoading();
                      adviceModel.clear();
                      adviceModel.addAll(state.adviceList);
                    } else if (state is GetUserAdvicesErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                    } else if (state is DeletePostSubscriberLoadingState) {
                    } else if (state is DeletePostSubscriberSuccessState) {
                      DashboardCubit.get(context).getAllPosts(GetPostsRequest(
                          currentUser: displayName, allPosts: true));
                    } else if (state is DeletePostSubscriberErrorState) {
                      showSnackBar(context, state.errorMessage);
                    } else if (state is DashboardNoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return homePageModel.isNotEmpty
                        ? RefreshIndicator(
                            color: AppColors.cTitle,
                            backgroundColor: AppColors.cWhite,
                            onRefresh: refreshLastPosts,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return DashboardPostView(
                                    index: index,
                                    id: homePageModel[index].postModel.id!,
                                    time: homePageModel[index].postModel.time!,
                                    postUsername:
                                        homePageModel[index].postModel.username,
                                    postUserImage: homePageModel[index]
                                        .postModel
                                        .userImage,
                                    loggedInUserName: displayName,
                                    loggedInUserImage: photoUrl,
                                    postAlsha: homePageModel[index]
                                        .postModel
                                        .postAlsha,
                                    commentsList: homePageModel[index]
                                        .postModel
                                        .commentsList,
                                    emojisList: homePageModel[index]
                                        .postModel
                                        .emojisList,
                                    statusBarHeight: statusBarHeight,
                                    addNewComment: (int status) {
                                      if (status == -1) {
                                        DeletePostSubscriberRequest
                                            deletePostSubscriberRequest =
                                            DeletePostSubscriberRequest(
                                                postSubscribersModel:
                                                    PostSubscribersModel(
                                          username: homePageModel[index]
                                              .postModel
                                              .username,
                                          userEmail: homePageModel[index]
                                              .postModel
                                              .userEmail,
                                          userImage: photoUrl,
                                          postId: homePageModel[index]
                                              .postModel
                                              .id!,
                                        ));
                                        DashboardCubit.get(context)
                                            .deletePostSubscriber(
                                                deletePostSubscriberRequest);
                                      } else if (status == 0) {
                                        DashboardCubit.get(context).getAllPosts(
                                            GetPostsRequest(
                                                currentUser: displayName,
                                                allPosts: true));
                                      }
                                    },
                                    postUpdated: () {
                                      DashboardCubit.get(context).getAllPosts(
                                          GetPostsRequest(
                                              currentUser: displayName,
                                              allPosts: true));
                                    },
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
            : Expanded(
                child: BlocConsumer<DashboardCubit, DashboardState>(
                  listener: (context, state) {
                    if (state is GetUserAdvicesLoadingState) {
                      showLoading();
                    } else if (state is GetUserAdvicesSuccessState) {
                      hideLoading();
                      adviceModel.clear();
                      adviceModel.addAll(state.adviceList);
                    } else if (state is GetUserAdvicesErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                    } else if (state is DashboardNoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return adviceModel.isNotEmpty
                        ? RefreshIndicator(
                            color: AppColors.cTitle,
                            backgroundColor: AppColors.cWhite,
                            onRefresh: refreshAdvices,
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AdviceView(
                                      adviceId: adviceModel[index].adviceId!,
                                      adviceText: adviceModel[index].adviceText,
                                      username: adviceModel[index].username,
                                      userImage: adviceModel[index].userImage,
                                      userEmail: adviceModel[index].userEmail,
                                      statusBarHeight: statusBarHeight,
                                      time: adviceModel[index].time,
                                      index: index);
                                },
                                itemCount: adviceModel.length),
                          )
                        : SizedBox(
                            height: MediaQuery.sizeOf(context).height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    AppStrings.noAdvices,
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
