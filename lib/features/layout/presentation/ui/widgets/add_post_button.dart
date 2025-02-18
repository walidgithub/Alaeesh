import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../home_page/data/model/post_subscribers_model.dart';
import '../../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../../home_page/presentation/bloc/home_page_cubit.dart';
import '../../../../welcome/presentation/bloc/welcome_cubit.dart';
import '../../../../welcome/presentation/bloc/welcome_state.dart';
import 'add_post_bottom_sheet.dart';

class AddPostButton extends StatelessWidget {
  double statusBarHeight;
  String displayName;
  String photoUrl;
  String email;
  String role;
  Function getHomePosts;
  AddPostButton({super.key, required this.photoUrl, required this.displayName, required this.email, required this.role, required this.statusBarHeight, required this.getHomePosts});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WelcomeCubit>(),
      child:
      BlocConsumer<WelcomeCubit, WelcomeState>(
          listener: (context, state) {
            if (state
            is GetUserPermissionsLoadingState) {
              showLoading();
            } else if (state
            is GetUserPermissionsSuccessState) {
              hideLoading();
              if (role == "guest") {
                onError(
                    context, AppStrings.guest);
                return;
              }
              if (state
                  .userPermissionsModel.enableAdd ==
                  "yes") {
                showModalBottomSheet(
                  context: context,
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.sizeOf(context)
                          .height -
                          statusBarHeight -
                          100.h,
                      width: MediaQuery.sizeOf(context)
                          .width),
                  isScrollControlled: true,
                  barrierColor: AppColors.cTransparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  builder: (context2) {
                    return Directionality(
                        textDirection:
                        TextDirection.rtl,
                        child: AddPostBottomSheet(
                          username: displayName,
                          userImage: photoUrl,
                          userEmail: email,
                          statusBarHeight:
                          statusBarHeight,
                          postAdded: (String postId) {
                            AddPostSubscriberRequest
                            addPostSubscriberRequest =
                            AddPostSubscriberRequest(
                                postSubscribersModel:
                                PostSubscribersModel(
                                  username: displayName,
                                  userImage: photoUrl,
                                  userEmail: email,
                                  postId: postId,
                                ));
                            HomePageCubit.get(context)
                                .addPostSubscriber(
                                addPostSubscriberRequest);
                            getHomePosts();
                          },
                        ));
                  },
                );
              } else {
                onError(
                    context, AppStrings.preventMessage);
              }
            } else if (state
            is GetUserPermissionsErrorState) {
              hideLoading();
            } else if (state
            is WelcomeNoInternetState) {
              hideLoading();
              onError(context, AppStrings.noInternet);
            }
          },
          builder: (context, state) {
            return Bounceable(
              onTap: () {
                WelcomeCubit.get(context)
                    .getUserPermissions(displayName);
              },
              child: SvgPicture.asset(
                AppAssets.addPost,
                width: 30.w,
              ),
            );
          }),
    );
  }
}
