import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/layout/presentation/ui/widgets/drawer_info_page.dart';
import 'package:last/features/layout/presentation/ui/widgets/menu_view.dart';
import 'package:last/features/layout/presentation/ui/widgets/profile_data_view.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/dashboard_tab.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/home_tab.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/messages_tab.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/mine_tab.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/notification_tab.dart';
import 'package:last/features/layout/presentation/ui/widgets/tabs/trending_tab.dart';
import 'package:last/features/messages/data/model/requests/get_messages_request.dart';
import 'package:last/features/messages/presentation/bloc/messages_cubit.dart';
import 'package:last/features/trending/presentation/ui/trending_view.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/dialogs/back_dialog.dart';
import '../../../../../core/utils/ui_components/tab_icon.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/app_pref.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../dashboard/presentation/ui/dashboard_view.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../home_page/presentation/bloc/home_page_cubit.dart';
import '../../../home_page/presentation/ui/home_view.dart';
import '../../../messages/presentation/bloc/messages_state.dart';
import '../../../messages/presentation/ui/messages_view.dart';
import '../../../mine/presentation/ui/mine_view.dart';
import '../../../notifications/data/model/requests/get_notifications_request.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';
import '../../../notifications/presentation/ui/notifications_view.dart';
import '../../../welcome/presentation/bloc/welcome_cubit.dart';
import 'functions/show_menu_popup.dart';
import 'functions/show_user_popup_menu.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int _notificationsBadgeAmount = 0;
  int _messagesBadgeAmount = 0;
  final bool _notificationsBadge = true;
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
  String role = "";

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
    getHomePosts(displayName, allPosts: true, addNewPost: false);
  }

  void getUnSeenMessagesCount() {
    MessagesCubit.get(context)
        .getUnSeenMessages(GetMessagesRequest(username: displayName));
  }

  void getUnSeenNotificationsCount() {
    NotificationsCubit.get(context)
        .getUnSeenNotifications(GetNotificationsRequest(username: displayName));
  }

  void getUserPermissions() {
    WelcomeCubit.get(context).getUserPermissions(displayName);
  }

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      loadingUserData = false;
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
      role = userData['role'] ?? '';
    });
    getUnSeenMessagesCount();
    getUnSeenNotificationsCount();
    getUserPermissions();
  }

  getHomePosts(String displayName,
      {bool? allPosts, String? username, bool? addNewPost}) {
    if (addNewPost!) {
      HomePageCubit.get(context).getHomePostsAndScrollToTop(GetPostsRequest(
          currentUser: displayName, allPosts: allPosts!, username: username));
    } else {
      HomePageCubit.get(context).getHomePosts(GetPostsRequest(
          currentUser: displayName, allPosts: allPosts!, username: username));
    }
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
                    MenuView(
                        displayName: displayName,
                        photoUrl: photoUrl,
                        email: email,
                        role: role,
                        statusBarHeight: statusBarHeight,
                        getHomePosts: () {
                          getHomePosts(displayName,
                              allPosts: true, addNewPost: true);
                        },
                        addPost: addPost,
                        showMenuPopupMenu: () {
                          showMenuPopupMenu(
                              context,
                              _appSecureDataHelper,
                              _appPreferences,
                              addPost,
                              scaffoldKey,
                              updateSearching,
                          role);
                        }),
                    ProfileDataView(
                      photoUrl: photoUrl,
                      displayName: displayName,
                      showUserPopupMenu: () {
                        showUserPopupMenu(
                            context, _appSecureDataHelper, _appPreferences);
                      },
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
                  BlocConsumer<MessagesCubit, MessagesState>(
                      listener: (context, state) {
                    if (state is GetUnSeenMessagesLoadingState) {
                      showLoading();
                    } else if (state is GetUnSeenMessagesSuccessState) {
                      hideLoading();
                      setState(() {
                        _messagesBadgeAmount = state.unSeenMessagesCount;
                      });
                    } else if (state is GetUnSeenMessagesErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorMessage);
                    } else if (state is MessagesNoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  }, builder: (context, state) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            addPost = false;
                            _messagesBadgeAmount = 0;
                          });
                          toggleIcon(5);
                        },
                        child: MessagesTab(
                            selectedWidgets: selectedWidgets,
                            selectScreen: selectScreen,
                            messagesBadge: _messagesBadge,
                            messagesBadgeAmount: _messagesBadgeAmount));
                  }),
                  role == "admin"
                      ? DashboardTab(
                          selectedWidgets: selectedWidgets,
                          selectScreen: selectScreen,
                          goTo: () {
                            setState(() {
                              addPost = false;
                            });
                            toggleIcon(4);
                          },
                        )
                      : Container(),
                  BlocConsumer<NotificationsCubit, NotificationsState>(
                      listener: (context, state) {
                    if (state is GetUnSeenNotificationsLoadingState) {
                      showLoading();
                    } else if (state is GetUnSeenNotificationsSuccessState) {
                      hideLoading();
                      setState(() {
                        _notificationsBadgeAmount =
                            state.unSeenNotificationsCount;
                      });
                    } else if (state is GetUnSeenNotificationsErrorState) {
                      hideLoading();
                      showSnackBar(context, state.errorNotification);
                    } else if (state is NotificationsNoInternetState) {
                      hideLoading();
                      onError(context, AppStrings.noInternet);
                    }
                  }, builder: (context, state) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            addPost = false;
                            _notificationsBadgeAmount = 0;
                          });
                          toggleIcon(3);
                        },
                        child: NotificationTab(
                          selectScreen: selectScreen,
                          notificationsBadge: _notificationsBadge,
                          notificationsBadgeAmount: _notificationsBadgeAmount,
                          selectedWidgets: selectedWidgets,
                        ));
                  }),
                  TrendingTab(
                      goTo: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(2);
                      },
                      selectScreen: selectScreen,
                      selectedWidgets: selectedWidgets),
                  MineTab(
                      goTo: () {
                        setState(() {
                          addPost = false;
                        });
                        toggleIcon(1);
                      },
                      selectScreen: selectScreen,
                      selectedWidgets: selectedWidgets),
                  HomeTab(
                      goTo: () {
                        setState(() {
                          addPost = true;
                        });
                        toggleIcon(0);
                      },
                      selectScreen: selectScreen,
                      selectedWidgets: selectedWidgets),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
