import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/features/trending/presentation/ui/widgets/suggested_user_view.dart';
import 'package:last/features/trending/presentation/ui/widgets/top_post_view.dart';
import 'package:last/features/trending/presentation/ui/widgets/user_subscriptions_bottom_sheet.dart';

import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../home_page/data/model/subscribers_model.dart';
import '../../data/model/requests/get_suggested_user_posts_request.dart';
import '../../data/model/requests/get_top_posts_request.dart';
import '../../data/model/suggested_user_model.dart';
import '../bloc/trending_cubit.dart';
import '../bloc/trending_state.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  int selectedPost = 0;
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = AppStrings.guestUsername;
  String photoUrl = "";
  List<SubscribersModel> subscribersList = [];
  bool showAll = true;
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
    });
    getTopPosts(displayName);
    getSuggestedUsers();
  }

  getTopPosts(String displayName) {
    TrendingCubit.get(context)
        .getTopPosts(GetTopPostsRequest(currentUser: displayName));
  }

  getSuggestedUsers() {
    TrendingCubit.get(context)
        .getSuggestedUsers();
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
          homePageModel.clear();
          homePageModel.addAll(state.homePageModel);
        } else if (state is GetTopPostsErrorState) {
          showSnackBar(context, state.errorMessage);
          hideLoading();
        } else if (state is GetSuggestedUsersLoadingState) {
          showLoading();
        } else if (state is GetSuggestedUsersSuccessState) {
          hideLoading();
          suggestedUserModel.clear();
          suggestedUserModel.addAll(state.suggestedUserModel);
        } else if (state is GetSuggestedUsersErrorState) {
          showSnackBar(context, state.errorMessage);
          hideLoading();
        } else if (state is AddSubscriberLoadingState) {
        } else if (state is AddSubscriberSuccessState) {
          TrendingCubit.get(context).getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is AddSubscriberErrorState) {
          showSnackBar(context, state.errorMessage);
        } else if (state is DeleteSubscriberLoadingState) {
        } else if (state is DeleteSubscriberSuccessState) {
          TrendingCubit.get(context).getTopPosts(GetTopPostsRequest(currentUser: displayName));
        } else if (state is DeleteSubscriberErrorState) {
          showSnackBar(context, state.errorMessage);
        } else if (state is GetSuggestedUserPostsLoadingState) {
          showLoading();
        } else if (state is GetSuggestedUserPostsSuccessState) {
          hideLoading();
          showModalBottomSheet(
            context: context,
            constraints: BoxConstraints.expand(
                height: MediaQuery.sizeOf(context)
                    .height -
                    statusBarHeight -
                    50.h,
                width:
                MediaQuery.sizeOf(context).width),
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
                child: UserSubscriptionsBottomSheet(
                    getUserPosts: () {},
                  addOrRemoveSubscriber: () {},
                  getPostData: () {},
                  statusBarHeight: statusBarHeight,
                  homePageModel: state.homePageModel,
                  postUserImage: state.homePageModel[0].postModel.userImage,
                  postUsername: state.homePageModel[0].postModel.username,
                ),
              );
            },
          );
        } else if (state is GetSuggestedUserPostsErrorState) {
          hideLoading();
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppConstants.heightBetweenElements,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.suggestedUsers,
                  style: AppTypography.kBold16.copyWith(color: AppColors.cSecondary),
                ),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 180.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SuggestedUserView(
                        userImage: suggestedUserModel[index].userImage,
                        userName: suggestedUserModel[index].userName,
                        subscriptionsCount: suggestedUserModel[index].subscriptionsCount,
                        getUserPosts: () {
                          GetSuggestedUserPostsRequest getSuggestedUserPostsRequest = GetSuggestedUserPostsRequest(
                            userName: suggestedUserModel[index].userName, currentUser: displayName
                          );
                          TrendingCubit.get(context).getSuggestedUserPosts(getSuggestedUserPostsRequest);
                        },
                      );
                    },
                    itemCount: suggestedUserModel.length,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: AppConstants.heightBetweenElements,
            ),
            Text(
              AppStrings.topPosts,
              style: AppTypography.kBold16.copyWith(color: AppColors.cSecondary),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return TopPostView(
                                getUserPosts: () {},
                                getPostData: () {},
                                addOrRemoveSubscriber: (int status) {
                                  if (status == -1) {
                                    DeleteSubscriberRequest
                                    deleteSubscriberRequest =
                                    DeleteSubscriberRequest(
                                        username: displayName,
                                        postAuther: homePageModel[index]
                                            .postModel
                                            .username);
                                    TrendingCubit.get(context)
                                        .deleteSubscriber(deleteSubscriberRequest);
                                  } else if (status == 1) {
                                    AddSubscriberRequest addSubscriberRequest =
                                    AddSubscriberRequest(
                                        username: displayName,
                                        postAuther: homePageModel[index]
                                            .postModel
                                            .username);
                                    TrendingCubit.get(context)
                                        .addSubscriber(addSubscriberRequest);
                                  }
                                  setState(() {
                                    selectedPost = index;
                                  });
                                },
                                index: index,
                                id: homePageModel[index].postModel.id!,
                                time: homePageModel[index].postModel.time,
                                postUsername:
                                homePageModel[index].postModel.username,
                                postUserImage:
                                homePageModel[index].postModel.userImage,
                                loggedInUserName: displayName,
                                loggedInUserImage: photoUrl,
                                postAlsha: homePageModel[index].postModel.postAlsha,
                                commentsList:
                                homePageModel[index].postModel.commentsList,
                                emojisList:
                                homePageModel[index].postModel.emojisList,
                                statusBarHeight: statusBarHeight,
                                userSubscribed: homePageModel[index].userSubscribed,
                              );
                            },
                            itemCount: homePageModel.length,
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }
}
