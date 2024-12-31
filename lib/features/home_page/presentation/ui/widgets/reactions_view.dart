import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../domain/entities/emoji_entity.dart';

class ReactionsView extends StatefulWidget {
  Function returnEmojiData;
  Function deleteEmojiData;
  ReactionsView({super.key, required this.returnEmojiData, required this.deleteEmojiData});

  @override
  State<ReactionsView> createState() => _ReactionsViewState();
}

class _ReactionsViewState extends State<ReactionsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      height: 50.h,
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
            return ZoomIn(
              duration: Duration(milliseconds: 300 * index),
              child: Bounceable(
                onTap: () {
                  if (emojisData[index].id != "0") {
                    widget.returnEmojiData(emojisData.where((element) => element.id == emojisData[index].id).first);
                  } else {
                    widget.deleteEmojiData();
                  }
                },
                child: Row(
                  children: [
                    Text(emojisData[index].emojiData, style: emojisData[index].id == "0" ? AppTypography.kLight16.copyWith(color: AppColors.cTitle) : AppTypography.kLight20,),
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
