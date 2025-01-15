import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/home_page/data/model/home_page_model.dart';
import 'package:last/features/mine/presentation/ui/widgets/mine_post_view.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../../home_page/data/model/post_subscribers_model.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../data/model/requests/get_mine_request.dart';
import '../bloc/mine_state.dart';
import '../bloc/myine_cubit.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
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
    getMine(displayName);
  }

  getMine(String displayName) {
    GetMineRequest getMineRequest =
        GetMineRequest(userName: displayName);
    MineCubit.get(context).getMine(getMineRequest);
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
              child: BlocConsumer<MineCubit, MineState>(
        listener: (context, state) {
          if (state is GetMineLoadingState) {
            showLoading();
          } else if (state is GetMineSuccessState) {
            hideLoading();
            mineModel.clear();
            mineModel.addAll(state.homePageModel);
          } else if (state is GetMineErrorState) {
            showSnackBar(context, state.errorMessage);
            hideLoading();
          } else if (state is DeletePostSubscriberLoadingState) {
          } else if (state is DeletePostSubscriberSuccessState) {
            MineCubit.get(context)
                .getMine(GetMineRequest(userName: displayName));
          } else if (state is DeletePostSubscriberErrorState) {
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return mineModel.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: AppConstants.heightBetweenElements),
                    Center(
                      child: Text(
                        AppStrings.mineSubscriptions,
                        style: AppTypography.kBold24
                            .copyWith(color: AppColors.cTitle),
                      ),
                    ),
                    SizedBox(height: AppConstants.heightBetweenElements),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MinePostView(
                            index: index,
                            id: mineModel[index].postModel.id!,
                            time: mineModel[index].postModel.time,
                            postUsername:
                            mineModel[index].postModel.username,
                            postUserImage:
                            mineModel[index].postModel.userImage,
                            loggedInUserName: displayName,
                            loggedInUserImage: photoUrl,
                            postAlsha: mineModel[index].postModel.postAlsha,
                            commentsList:
                            mineModel[index].postModel.commentsList,
                            emojisList:
                            mineModel[index].postModel.emojisList,
                            addNewEmoji: (int status) {
                              if (status == -1) {
                                DeletePostSubscriberRequest
                                    deletePostSubscriberRequest =
                                    DeletePostSubscriberRequest(
                                        postSubscribersModel:
                                            PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  postId: mineModel[index].postModel.id!,
                                ));
                                MineCubit.get(context)
                                    .deletePostSubscriber(
                                        deletePostSubscriberRequest);
                              } else if (status == 0) {
                                MineCubit.get(context).getMine(
                                    GetMineRequest(
                                        userName: displayName));
                              }
                            },
                            statusBarHeight: statusBarHeight,
                            postSubscribersList: mineModel[index]
                                .postModel
                                .postSubscribersList,
                            postUpdated: () {
                              MineCubit.get(context).getMine(
                                  GetMineRequest(
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
                                  postId: mineModel[index].postModel.id!,
                                ));
                                MineCubit.get(context)
                                    .deletePostSubscriber(
                                        deletePostSubscriberRequest);
                              } else if (status == 0) {
                                MineCubit.get(context).getMine(
                                    GetMineRequest(
                                        userName: displayName));
                              }
                            },
                          );
                        },
                        itemCount: mineModel.length)
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
