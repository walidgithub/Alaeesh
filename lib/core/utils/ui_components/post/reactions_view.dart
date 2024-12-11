import 'package:alaeeeesh/core/utils/constant/app_typography.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/home_page/domain/entity/emoji_entity.dart';
import '../../constant/app_constants.dart';
import '../../style/app_colors.dart';

class ReactionsView extends StatefulWidget {
  Function returnEmojiData;
  ReactionsView({super.key, required this.returnEmojiData});

  @override
  State<ReactionsView> createState() => _ReactionsViewState();
}

class _ReactionsViewState extends State<ReactionsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 40.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.cWhite,
        border: Border.all(color: AppColors.cTitle,width: 2.w),
          borderRadius: BorderRadius.all(Radius.circular(30.r))
      ),
      child: Center(
        child: ListView.builder(
          itemCount: emojisData.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 200 * index),
              child: Bounceable(
                onTap: () {
                  widget.returnEmojiData(emojisData.where((element) => element.id == emojisData[index].id).first);
                },
                child: Row(
                  children: [
                    Text(emojisData[index].emojiData, style: AppTypography.kLight20,),
                    SizedBox(width: 5.w),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
