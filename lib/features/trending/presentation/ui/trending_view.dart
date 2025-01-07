import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/features/trending/presentation/ui/widgets/top_post_view.dart';

import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/subscribers_model.dart';
import '../bloc/trending_cubit.dart';
import '../bloc/trending_state.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
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
    return BlocProvider(
      create: (context) => sl<TrendingCubit>()..getTopPosts(),
      child: BlocConsumer<TrendingCubit, TrendingState>(
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
                    height: 60.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            CircleAvatar(
                                radius: 25.r,
                                backgroundColor: AppColors.cWhite,
                                child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.cTitle,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                              strokeWidth: 2.w,
                                              color: AppColors.cTitle,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(AppAssets.profile),
                                        imageUrl:
                                        "https://lh3.googleusercontent.com/a/ACg8ocIv2ap8Ovmh0Yk6xst0Ebt6niVU9q4_F8bXTpqq86XPN5hZ8_Q=s96-c",
                                      ),
                                    ))),
                            SizedBox(
                              width: 10.w,
                            )
                          ],
                        );
                      },
                      itemCount: 10,
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
                                  postSubscribersList: homePageModel[index]
                                      .postModel
                                      .postSubscribersList,
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
      ),
    );
  }
}
