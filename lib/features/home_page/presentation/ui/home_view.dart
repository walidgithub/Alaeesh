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
                  if (showCommentBottomSheet) {
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
                              addNewComment: () {
                                HomePageCubit.get(context).getAllPosts();
                                setState(() {
                                  if (postModel[selectedPost].commentsList.length > 1) {
                                    showCommentBottomSheet = true;
                                  }
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
                            addNewComment: () {
                              HomePageCubit.get(context).getAllPosts();
                              selectedPost = index;
                              setState(() {
                                if (postModel[selectedPost].commentsList.length > 1) {
                                  showCommentBottomSheet = true;
                                }
                              });
                            },
                            addNewEmoji: () {
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
