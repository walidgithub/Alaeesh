import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/layout/presentation/ui/widgets/add_post_bottom_sheet.dart';
import 'package:last/features/layout/presentation/ui/widgets/drawer_info_page.dart';
import 'package:last/features/trending/presentation/ui/trending_view.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/dialogs/back_dialog.dart';
import '../../../../../core/utils/ui_components/tab_icon.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/app_pref.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../dashboard/presentation/ui/dashboard_view.dart';
import '../../../home_page/data/model/post_subscribers_model.dart';
import '../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../home_page/presentation/bloc/home_page_cubit.dart';
import '../../../home_page/presentation/ui/home_view.dart';
import '../../../messages/presentation/ui/messages.dart';
import '../../../mine/presentation/ui/mine_view.dart';
import '../../../notifications/presentation/ui/notifications_view.dart';
import '../../../welcome/presentation/bloc/welcome_cubit.dart';
import '../../../welcome/presentation/bloc/welcome_states.dart';
import 'package:badges/badges.dart' as badges;

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  final int _notificationBadgeAmount = 0;
  final int _messagesBadgeAmount = 0;
  final bool _showNotificationBadge = true;
  final bool _messagesBadge = true;
  String returnedUserName = '';
  bool addPost = true;

  final AppPreferences _appPreferences = sl<AppPreferences>();
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();
  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  bool loadingUserData = true;
  var userData;
  bool showAll = true;
  bool searching = false;

  void updateSearching(bool value) {
    setState(() {
      searching = value;
    });
    screens = [
      HomeView(searching: searching, showAllAgain: showAllAgain),
      MineView(),
      TrendingView(),
      NotificationsView(),
      DashboardView(),
      MessagesView(),
    ];
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<bool> selectedWidgets = [true, false, false, false, false, false];
  int selectScreen = 0;
  void toggleIcon(int index) {
    setState(() {
      for (int i = 0; i < selectedWidgets.length; i++) {
        selectedWidgets[i] = false;
      }
      selectedWidgets[index] = true;
      selectScreen = index;
    });
  }

  List<Widget> screens = [];

  Future<void> _showUserPopupMenu() async {
    await showMenu(
        context: context,
        color: AppColors.cWhite,
        menuPadding: EdgeInsets.zero,
        elevation: 4,
        position: RelativeRect.fromDirectional(
            textDirection: TextDirection.ltr,
            start: 0.w,
            top: 120.h,
            end: 20.w,
            bottom: 0),
        items: [
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: BlocProvider(
                create: (context) => sl<WelcomeCubit>(),
                child: BlocConsumer<WelcomeCubit, WelcomeState>(
                  listener: (context, state) async {
                    if (state is LogoutLoadingState) {
                      showLoading();
                    } else if (state is LogoutSuccessState) {
                      hideLoading();
                      await _appSecureDataHelper.clearUserData();
                      await _appPreferences.setUserLoggedOut();
                      Navigator.pushReplacementNamed(
                          context, Routes.welcomeRoute);
                    } else if (state is LogoutErrorState) {
                      showSnackBar(context, state.errorMessage);
                      hideLoading();
                    } else if (state is NoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cTitle),
                          borderRadius: BorderRadius.all(Radius.circular(5.r))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Bounceable(
                            onTap: () {
                              WelcomeCubit.get(context).logout();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.logout,
                                  width: 30.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  AppStrings.logout,
                                  style: AppTypography.kLight14,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Bounceable(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.switchUserRoute);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.switchUser,
                                  width: 25.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  AppStrings.switchUser,
                                  style: AppTypography.kLight14,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          addPost
                              ? Bounceable(
                                  onTap: () {
                                    setState(() {
                                      if (showAll) {
                                        showAll = false;
                                      } else {
                                        showAll = true;
                                      }
                                    });
                                    Navigator.pop(context);
                                    if (showAll) {
                                      getAllPosts(displayName, allPosts: true);
                                    } else {
                                      getAllPosts(displayName,
                                          allPosts: false,
                                          username: displayName);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        showAll
                                            ? AppAssets.profileIcon
                                            : AppAssets.all,
                                        width: 30.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        showAll
                                            ? AppStrings.profile
                                            : AppStrings.showAll,
                                        style: AppTypography.kLight14,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                ),
              ))
        ]);
  }

  Future<void> _showMenuPopupMenu() async {
    await showMenu(
        context: context,
        color: AppColors.cWhite,
        menuPadding: EdgeInsets.zero,
        elevation: 4,
        position: RelativeRect.fromDirectional(
            textDirection: TextDirection.ltr,
            start: 20.w,
            top: 120.h,
            end: 0.w,
            bottom: 0),
        items: [
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: BlocProvider(
                create: (context) => sl<WelcomeCubit>(),
                child: BlocConsumer<WelcomeCubit, WelcomeState>(
                  listener: (context, state) async {
                    if (state is LogoutLoadingState) {
                      showLoading();
                    } else if (state is LogoutSuccessState) {
                      hideLoading();
                      await _appSecureDataHelper.clearUserData();
                      await _appPreferences.setUserLoggedOut();
                      Navigator.pushReplacementNamed(
                          context, Routes.welcomeRoute);
                    } else if (state is LogoutErrorState) {
                      showSnackBar(context, state.errorMessage);
                      hideLoading();
                    } else if (state is NoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cTitle),
                          borderRadius: BorderRadius.all(Radius.circular(5.r))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          addPost
                              ? Bounceable(
                                  onTap: () {
                                    Navigator.pop(context);
                                    updateSearching(true);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.search,
                                        width: 30.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        AppStrings.searchForPost,
                                        style: AppTypography.kLight14,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          addPost
                              ? SizedBox(
                                  height: 10.h,
                                )
                              : Container(),
                          Bounceable(
                            onTap: () {
                              Navigator.pop(context);
                              scaffoldKey.currentState?.openDrawer();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.drawer,
                                  width: 30.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  AppStrings.showDrawer,
                                  style: AppTypography.kLight14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ))
        ]);
  }

  @override
  void initState() {
    toggleIcon(0);
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    screens = [
      HomeView(
        searching: searching,
        showAllAgain: showAllAgain,
      ),
      MineView(),
      TrendingView(),
      NotificationsView(),
      DashboardView(),
      MessagesView(),
    ];
    super.initState();
  }

  void showAllAgain() {
    getAllPosts(displayName, allPosts: true);
  }

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      loadingUserData = false;
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
    });
  }

  getAllPosts(String displayName, {bool? allPosts, String? username}) {
    HomePageCubit.get(context).getAllPosts(GetPostsRequest(
        currentUser: displayName, allPosts: allPosts!, username: username));
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: SafeArea(
          child: Scaffold(
        key: scaffoldKey,
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: const DrawerInfo()),
        body: bodyContent(context, statusBarHeight),
      )),
    );
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 85.h),
              child: screens[selectScreen]),
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeInRight(
                      duration: Duration(milliseconds: AppConstants.animation),
                      child: Row(
                        children: [
                          Bounceable(
                              onTap: () {
                                _showMenuPopupMenu();
                              },
                              child: SvgPicture.asset(
                                AppAssets.mainMenu,
                                width: 30.w,
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          addPost
                              ? Bounceable(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      constraints: BoxConstraints.expand(
                                          height: MediaQuery.sizeOf(context)
                                                  .height -
                                              statusBarHeight -
                                              100.h,
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
                                            child: AddPostBottomSheet(
                                              username: displayName,
                                              userImage: photoUrl,
                                              statusBarHeight: statusBarHeight,
                                              postAdded: (String postId) {
                                                AddPostSubscriberRequest
                                                    addPostSubscriberRequest =
                                                    AddPostSubscriberRequest(
                                                        postSubscribersModel:
                                                            PostSubscribersModel(
                                                  username: displayName,
                                                  userImage: photoUrl,
                                                  postId: postId,
                                                ));
                                                HomePageCubit.get(context)
                                                    .addPostSubscriber(
                                                        addPostSubscriberRequest);

                                                getAllPosts(displayName,
                                                    allPosts: true);
                                              },
                                            ));
                                      },
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.addPost,
                                    width: 30.w,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    FadeInLeft(
                      duration: Duration(milliseconds: AppConstants.animation),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(AppStrings.hello,
                                    style: AppTypography.kBold14
                                        .copyWith(color: AppColors.cTitle)),
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: AppTypography.kBold14
                                        .copyWith(color: AppColors.cTitle),
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Bounceable(
                              onTap: () {
                                _showUserPopupMenu();
                              },
                              child: CircleAvatar(
                                  radius: 30.r,
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
                                          imageUrl: photoUrl,
                                        ),
                                      )))),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: AppColors.grey,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 5.h,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(5);
                      },
                      child: badges.Badge(
                        position:
                            badges.BadgePosition.topStart(top: 0, start: 0),
                        badgeAnimation: const badges.BadgeAnimation.slide(
                          disappearanceFadeAnimationDuration:
                              Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                        ),
                        showBadge: _messagesBadge,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.cPrimary,
                        ),
                        badgeContent: Text(
                          _messagesBadgeAmount.toString(),
                          style: const TextStyle(color: AppColors.cWhite),
                        ),
                        child: TabIcon(
                          selectedWidgets: selectedWidgets,
                          selectScreen: selectScreen,
                          index: 5,
                          heightSize: 50.h,
                          widthSize: 50.w,
                          blueIcon: AppAssets.message,
                          whiteIcon: AppAssets.messageWhite,
                          padding: 5.w,
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(4);
                      },
                      child: TabIcon(
                        selectedWidgets: selectedWidgets,
                        selectScreen: selectScreen,
                        index: 4,
                        heightSize: 50.h,
                        widthSize: 50.w,
                        blueIcon: AppAssets.dashboard,
                        whiteIcon: AppAssets.dashboardWhite,
                        padding: 5.w,
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(3);
                      },
                      child: badges.Badge(
                        position:
                            badges.BadgePosition.topStart(top: 0, start: 0),
                        badgeAnimation: const badges.BadgeAnimation.slide(
                          disappearanceFadeAnimationDuration:
                              Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                        ),
                        showBadge: _showNotificationBadge,
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.cPrimary,
                        ),
                        badgeContent: Text(
                          _notificationBadgeAmount.toString(),
                          style: const TextStyle(color: AppColors.cWhite),
                        ),
                        child: TabIcon(
                          selectedWidgets: selectedWidgets,
                          selectScreen: selectScreen,
                          index: 3,
                          heightSize: 45.h,
                          widthSize: 45.w,
                          blueIcon: AppAssets.notification,
                          whiteIcon: AppAssets.notificationWhite,
                          padding: 5.w,
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(2);
                      },
                      child: TabIcon(
                        selectedWidgets: selectedWidgets,
                        selectScreen: selectScreen,
                        index: 2,
                        heightSize: 45.h,
                        widthSize: 45.w,
                        blueIcon: AppAssets.trending,
                        whiteIcon: AppAssets.trendingWhite,
                        padding: 5.w,
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(1);
                      },
                      child: TabIcon(
                        selectedWidgets: selectedWidgets,
                        selectScreen: selectScreen,
                        index: 1,
                        heightSize: 50.h,
                        widthSize: 50.w,
                        blueIcon: AppAssets.mine,
                        whiteIcon: AppAssets.mineWhite,
                        padding: 5.w,
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          addPost = true;
                        });
                        toggleIcon(0);
                      },
                      child: TabIcon(
                        selectedWidgets: selectedWidgets,
                        selectScreen: selectScreen,
                        index: 0,
                        blueIcon: AppAssets.home,
                        whiteIcon: AppAssets.homeWhite,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
