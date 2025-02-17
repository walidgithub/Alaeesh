import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import 'add_post_button.dart';

class MenuView extends StatelessWidget {
  Function showMenuPopupMenu;
  bool addPost;
  double statusBarHeight;
  String displayName;
  String email;
  String photoUrl;
  Function getHomePosts;
  MenuView({super.key,required this.displayName,required this.photoUrl, required this.email, required this.statusBarHeight, required this.getHomePosts, required this.addPost, required this.showMenuPopupMenu});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Row(
        children: [
          Bounceable(
              onTap: () {
                showMenuPopupMenu();
              },
              child: SvgPicture.asset(
                AppAssets.mainMenu,
                width: 30.w,
              )),
          SizedBox(
            width: 10.w,
          ),
          addPost
              ? AddPostButton(
            statusBarHeight: statusBarHeight,
            displayName: displayName,
            email: email,
            photoUrl: photoUrl,
            getHomePosts: () {
              getHomePosts();
            },
          )
              : Container(),
        ],
      ),
    );
  }
}
