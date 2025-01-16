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
      width: 270.w,
      height: 100.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.cWhite,
        border: Border.all(color: AppColors.cTitle, width: 2.w),
        borderRadius: BorderRadius.all(Radius.circular(30.r)),
      ),
      child: Row(
        children: [
          Bounceable(
            onTap: () {
              widget.deleteEmojiData();
            },
            child: Text(
              emojisData[0].emojiData,
              style: AppTypography.kLight16.copyWith(color: AppColors.cTitle),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: List.generate(
                  emojisData.length - 1,
                      (index) {
                    return ZoomIn(
                      duration: Duration(milliseconds: 150 * (index + 1)),
                      child: Bounceable(
                        onTap: () {
                          widget.returnEmojiData(emojisData[index + 1]);
                        },
                        child: Text(
                          emojisData[index + 1].emojiData,
                          style: AppTypography.kLight20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
