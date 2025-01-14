import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/home_page/data/model/home_page_model.dart';
import 'package:last/features/my_activities/presentation/bloc/my_activities_cubit.dart';
import 'package:last/features/my_activities/presentation/bloc/my_activities_state.dart';
import 'package:last/features/my_activities/presentation/ui/widgets/my_activities_post_view.dart';

import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../home_page/data/model/post_subscribers_model.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../data/model/requests/get_my_activities_request.dart';

class MyActivityView extends StatefulWidget {
  const MyActivityView({super.key});

  @override
  State<MyActivityView> createState() => _MyActivityViewState();
}

class _MyActivityViewState extends State<MyActivityView> {
  final SecureStorageLoginHelper _appSecureDataHelper =
      sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
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
    getMyActivities(displayName);
  }

  getMyActivities(String displayName) {
    GetMyActivitiesRequest getMyActivitiesRequest =
        GetMyActivitiesRequest(userName: displayName);
    MyActivitiesCubit.get(context).getMyActivities(getMyActivitiesRequest);
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
          child: SingleChildScrollView(
              child: BlocConsumer<MyActivitiesCubit, MyActivitiesState>(
        listener: (context, state) {
          if (state is GetMyActivitiesLoadingState) {
            showLoading();
          } else if (state is GetMyActivitiesSuccessState) {
            hideLoading();
            myActivitiesModel.clear();
            myActivitiesModel.addAll(state.homePageModel);
          } else if (state is GetMyActivitiesErrorState) {
            showSnackBar(context, state.errorMessage);
            hideLoading();
          } else if (state is DeletePostSubscriberLoadingState) {
          } else if (state is DeletePostSubscriberSuccessState) {
            MyActivitiesCubit.get(context)
                .getMyActivities(GetMyActivitiesRequest(userName: displayName));
          } else if (state is DeletePostSubscriberErrorState) {
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return myActivitiesModel.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: AppConstants.heightBetweenElements,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MyActivitiesPostView(
                            index: index,
                            id: myActivitiesModel[index].postModel.id!,
                            time: myActivitiesModel[index].postModel.time,
                            postUsername:
                            myActivitiesModel[index].postModel.username,
                            postUserImage:
                            myActivitiesModel[index].postModel.userImage,
                            loggedInUserName: displayName,
                            loggedInUserImage: photoUrl,
                            postAlsha: myActivitiesModel[index].postModel.postAlsha,
                            commentsList:
                            myActivitiesModel[index].postModel.commentsList,
                            emojisList:
                            myActivitiesModel[index].postModel.emojisList,
                            addNewEmoji: (int status) {
                              if (status == -1) {
                                DeletePostSubscriberRequest
                                    deletePostSubscriberRequest =
                                    DeletePostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  postId: myActivitiesModel[index].postModel.id!,
                                ));
                                MyActivitiesCubit.get(context)
                                    .deletePostSubscriber(
                                        deletePostSubscriberRequest);
                              } else if (status == 0) {
                                MyActivitiesCubit.get(context).getMyActivities(
                                    GetMyActivitiesRequest(
                                        userName: displayName));
                              }
                            },
                            statusBarHeight: statusBarHeight,
                            postSubscribersList: myActivitiesModel[index]
                                .postModel
                                .postSubscribersList,
                            postUpdated: () {
                              MyActivitiesCubit.get(context).getMyActivities(
                                  GetMyActivitiesRequest(
                                      userName: displayName));
                            },
                            updateComment: (int status) {
                              if (status == -1) {
                                DeletePostSubscriberRequest
                                    deletePostSubscriberRequest =
                                    DeletePostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  postId: myActivitiesModel[index].postModel.id!,
                                ));
                                MyActivitiesCubit.get(context)
                                    .deletePostSubscriber(
                                        deletePostSubscriberRequest);
                              } else if (status == 0) {
                                MyActivitiesCubit.get(context).getMyActivities(
                                    GetMyActivitiesRequest(
                                        userName: displayName));
                              }
                            },
                          );
                        },
                        itemCount: myActivitiesModel.length)
                  ],
                )
              : SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          AppStrings.noActivities,
                          style: AppTypography.kBold14,
                        ),
                      ),
                    ],
                  ),
                );
        },
      )))
    ]);
  }
}
