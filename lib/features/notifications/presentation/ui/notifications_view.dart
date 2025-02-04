import '../../../../../core/utils/constant/app_constants.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../layout/presentation/ui/widgets/notification_view.dart';
import '../../data/model/notifications_model.dart';

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

  bool loadingUserData = true;
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
      loadingUserData = false;
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
      role = userData['role'] ?? '';
      
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
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppConstants.heightBetweenElements,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: NotificationView(
                                  id: notificationsList[index].postModel.id!,
                                  time: notificationsList[index].postModel.time!,
                                  username: notificationsList[index]
                                      .postModel
                                      .username,
                                  userImage: notificationsList[index]
                                      .postModel
                                      .userImage,
                                  postAlsha: notificationsList[index]
                                      .postModel
                                      .postAlsha,
                                  statusBarHeight: statusBarHeight),
                            );
                          },
                          itemCount: notificationsList.length)
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
