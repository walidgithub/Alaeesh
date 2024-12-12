import 'package:alaeeeesh/features/home_page/data/model/post_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/ui_components/post/post_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
        child: Scaffold(
      body: Directionality(
          textDirection: TextDirection.rtl, child: bodyContent(context, statusBarHeight)),
    ));
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return Column(
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
                      return PostView(
                          id: postModel[index].id,
                          time: postModel[index].time,
                          username: postModel[index]

                              .username,
                          userImage: postModel[index]

                              .userImage,
                          postAlsha: postModel[index]

                              .postAlsha,
                          emojisList: postModel[index]

                              .emojisList,
                          commentsList: postModel[index]

                              .commentsList,
                          emojiDataCount: postModel[index]

                              .emojiDataCount,
                          statusBarHeight: statusBarHeight);
                    },
                    itemCount: postModel.length)
              ],
            ),
          ),
        )
      ],
    );
  }
}
