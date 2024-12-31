import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/features/home_page/presentation/bloc/home_page_cubit.dart';
import 'package:last/features/home_page/presentation/ui/widgets/comments_bottom_sheet.dart';
import 'package:last/features/home_page/presentation/ui/widgets/post_view.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../data/model/post_model.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/subscribers_model.dart';
import '../bloc/home_page_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedPost = 0;
  bool showCommentBottomSheet = false;
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
        Expanded(
          child: SingleChildScrollView(
            child: BlocConsumer<HomePageCubit, HomePageState>(
              listener: (context, state) async {
                if (state is GetAllPostsLoadingState) {
                  showLoading();
                } else if (state is GetAllPostsSuccessState) {
                  hideLoading();
                  postModel.clear();
                  postModel.addAll(state.postModel);
                  if (showCommentBottomSheet &&
                      postModel[selectedPost].commentsList.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.sizeOf(context).height -
                              statusBarHeight -
                              150.h,
                          width: MediaQuery.sizeOf(context).width),
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
                          child: CommentsBottomSheet(
                              postId: postModel[selectedPost]
                                  .commentsList[0]
                                  .postId,
                              userName: postModel[selectedPost]
                                  .commentsList[0]
                                  .username,
                              userImage: postModel[selectedPost]
                                  .commentsList[0]
                                  .userImage,
                              addNewComment: (int status) {
                                if (status == 1) {
                                  AddSubscriberRequest addSubscriberRequest =
                                  AddSubscriberRequest(
                                      subscriberModel: SubscribersModel(
                                        username: postModel[selectedPost].username,
                                        userImage: postModel[selectedPost].userImage,
                                        postId: postModel[selectedPost].id!,
                                      ));
                                  HomePageCubit.get(context)
                                      .addSubscriber(addSubscriberRequest);
                                } else if (status == -1) {
                                  DeleteSubscriberRequest deleteSubscriberRequest =
                                  DeleteSubscriberRequest(
                                      subscriberModel: SubscribersModel(
                                        username: postModel[selectedPost].username,
                                        userImage: postModel[selectedPost].userImage,
                                        postId: postModel[selectedPost].id!,
                                      ));
                                  HomePageCubit.get(context)
                                      .deleteSubscriber(deleteSubscriberRequest);
                                } else if (status == 0) {}
                                HomePageCubit.get(context).getAllPosts();
                                setState(() {
                                  showCommentBottomSheet = true;
                                });
                              },
                              statusBarHeight: statusBarHeight,
                              commentsList:
                                  postModel[selectedPost].commentsList),
                        );
                      },
                    );
                    setState(() {
                      showCommentBottomSheet = false;
                    });
                  }
                } else if (state is GetAllPostsErrorState) {
                  showSnackBar(context, state.errorMessage);
                  hideLoading();
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(
                      height: AppConstants.heightBetweenElements,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PostView(
                            index: index,
                            id: postModel[index].id!,
                            time: postModel[index].time,
                            username: postModel[index].username,
                            userImage: postModel[index].userImage,
                            postAlsha: postModel[index].postAlsha,
                            commentsList: postModel[index].commentsList,
                            emojisList: postModel[index].emojisList,
                            addNewComment: (int status) {
                              if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                AddSubscriberRequest(
                                    subscriberModel: SubscribersModel(
                                      username: postModel[index].username,
                                      userImage: postModel[index].userImage,
                                      postId: postModel[index].id!,
                                    ));
                                HomePageCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              } else if (status == -1) {
                                DeleteSubscriberRequest deleteSubscriberRequest =
                                DeleteSubscriberRequest(
                                    subscriberModel: SubscribersModel(
                                      username: postModel[index].username,
                                      userImage: postModel[index].userImage,
                                      postId: postModel[index].id!,
                                    ));
                                HomePageCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 0) {}


                              HomePageCubit.get(context).getAllPosts();

                              selectedPost = index;
                              setState(() {
                                showCommentBottomSheet = true;
                              });
                            },
                            addNewEmoji: (int status) {
                              if (status == 1) {
                                AddSubscriberRequest addSubscriberRequest =
                                AddSubscriberRequest(
                                    subscriberModel: SubscribersModel(
                                      username: postModel[index].username,
                                      userImage: postModel[index].userImage,
                                      postId: postModel[index].id!,
                                    ));
                                HomePageCubit.get(context)
                                    .addSubscriber(addSubscriberRequest);
                              } else if (status == -1) {
                                DeleteSubscriberRequest deleteSubscriberRequest =
                                DeleteSubscriberRequest(
                                    subscriberModel: SubscribersModel(
                                      username: postModel[index].username,
                                      userImage: postModel[index].userImage,
                                      postId: postModel[index].id!,
                                    ));
                                HomePageCubit.get(context)
                                    .deleteSubscriber(deleteSubscriberRequest);
                              } else if (status == 0) {}

                              HomePageCubit.get(context).getAllPosts();
                            },
                            statusBarHeight: statusBarHeight,
                            postUpdated: () {
                              HomePageCubit.get(context).getAllPosts();
                            },
                            subscribersList: postModel[index].subscribersList,
                          );
                        },
                        itemCount: postModel.length)
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
