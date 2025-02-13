import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:last/features/notifications/presentation/ui/widgets/notification_view.dart';

import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../data/model/notifications_model.dart';
import '../../data/model/requests/get_notifications_request.dart';
import '../bloc/notifications_state.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  String role = "";
  String enableAdd = "";

  var userData;


  @override
  void initState() {
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    super.initState();
  }

  Future<void> refreshLastPosts() async {
    setState(() {
      NotificationsCubit.get(context).getUserNotifications(GetNotificationsRequest(username: displayName));
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
    getNotifications();
  }

  getNotifications() {
    NotificationsCubit.get(context).getUserNotifications(GetNotificationsRequest(username: displayName));
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
    return Column(children: [
      Expanded(
        child: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is GetNotificationsLoadingState) {
              showLoading();
            } else if (state is GetNotificationsSuccessState) {
              hideLoading();
              alaeeshNotificationsList.clear();
              alaeeshNotificationsList.addAll(state.alaeeshNotificationsList);
            } else if (state is GetNotificationsErrorState) {
              hideLoading();
              showSnackBar(context, state.errorNotification);
            } else if (state is NotificationsNoInternetState) {
              hideLoading();
              onError(context, AppStrings.noInternet);
            }
          },
          builder: (context, state) {
            return alaeeshNotificationsList.isNotEmpty ? RefreshIndicator(
              color: AppColors.cTitle,
              backgroundColor: AppColors.cWhite,
              onRefresh: refreshLastPosts,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: NotificationView(
                        statusBarHeight: statusBarHeight,
                        id: alaeeshNotificationsList[index].id!,
                        postId: alaeeshNotificationsList[index].postId,
                        username: alaeeshNotificationsList[index].username,
                        postAuthor: alaeeshNotificationsList[index].postAuthor,
                        authorImage: alaeeshNotificationsList[index].authorImage,
                        time: alaeeshNotificationsList[index].time,
                        notification: alaeeshNotificationsList[index].notification,
                        seen: alaeeshNotificationsList[index].seen,
                      ),
                    );
                  },
                  itemCount: alaeeshNotificationsList.length),
            ) : SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      AppStrings.noNotifications,
                      style: AppTypography.kBold12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],);
  }
}
