import 'package:alaeeeesh/core/utils/constant/app_strings.dart';
import 'package:alaeeeesh/core/utils/ui_components/post/reactions_view.dart';
import 'package:alaeeeesh/features/layout/ui/widgets/add_comment_bottom_sheet.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/constant/app_assets.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/constant/app_typography.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/card_divider.dart';
import '../../../../features/home_page/data/model/emoji_model.dart';
import '../../../../features/home_page/domain/entity/emoji_entity.dart';
import '../../../../features/layout/ui/widgets/comments_bottom_sheet.dart';
import '../../../../features/layout/ui/widgets/reactions_bottom_sheet.dart';
class CommentView extends StatefulWidget {
  final int id;
  final String comment;
  final String username;
  final String userImage;
  final String time;
  final List<EmojiModel> emojisList;
  int emojiDataCount;
  double statusBarHeight;
  CommentView(
      {super.key,
        required this.id,
        required this.comment,
        required this.username,
        required this.userImage,
        required this.time,
        required this.emojisList,
        required this.emojiDataCount,
        required this.statusBarHeight,
      });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  bool showReactionsBox = false;
  double reactPosition = 20.0;
  int reactionsCount = 0;

  @override
  void initState() {
    reactionsCount = widget.emojiDataCount;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: AppConstants.animation),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(8.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: AppColors.cWhite,
                                    child: ClipOval(
                                      child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.cTitle,
                                            width: 2,
                                          ),
                                        ),
                                        child: Image.asset(
                                          widget.userImage,
                                          width: 70.w,
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.username,
                                      style: AppTypography.kBold14
                                          .copyWith(color: AppColors.cTitle),
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        widget.time,
                                        style: AppTypography.kLight12
                                            .copyWith(color: AppColors.cBlack),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              widget.comment,
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.cBlack),
                            ),
                          ],
                        )),
                  ],
                ),
                const Divider(
                  color: AppColors.grey,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bounceable(
                      onTap: () {
                        setState(() {
                          if (showReactionsBox) {
                            showReactionsBox = false;
                          } else {
                            showReactionsBox = true;
                          }
                        });
                      },
                      child: SvgPicture.asset(
                        AppAssets.emoji,
                        width: 30.w,
                      ),
                    ),
                    widget.emojisList.isNotEmpty
                        ? Row(
                      children: [
                        Bounceable(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              constraints: BoxConstraints.expand(
                                  height: MediaQuery.sizeOf(context).height - widget.statusBarHeight - 300.h,
                                  width: MediaQuery.sizeOf(context).width
                              ),
                              isScrollControlled: true,
                              barrierColor: AppColors.cTransparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30.r),
                                ),
                              ),
                              builder: (context2) {
                                return ReactionsBottomSheet(statusBarHeight: widget.statusBarHeight,emojisList: widget.emojisList,);
                              },
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            height: 30.h,
                            child: Stack(
                              children: widget.emojisList
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                return Positioned(
                                    left: index * reactPosition,
                                    child: CircleAvatar(
                                        radius: 15.r,
                                        backgroundColor: AppColors.cWhite,
                                        child: ClipOval(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.cSecondary,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                entry.value.emojiData,
                                                style: AppTypography
                                                    .kExtraLight18,
                                              ),
                                            ),
                                          ),
                                        )));
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(reactionsCount.toString()),
                      ],
                    )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                const CardDivider(),
              ],
            ),
            showReactionsBox
                ? Positioned(
                left: 0,
                bottom: 10.h,
                child: ReactionsView(
                  returnEmojiData: (EmojiEntity returnedEmojiData) {
                    bool isUserReacted = widget.emojisList.where((element) => element.username == widget.username).isNotEmpty;
                    if (isUserReacted) {
                      widget.emojisList.removeWhere((element) => element.username == widget.username);
                      widget.emojisList.add(EmojiModel(
                          id: returnedEmojiData.id,
                          postId: widget.id,
                          username: widget.username,
                          userImage: widget.userImage,
                          emojiData: returnedEmojiData.emojiData));
                    } else {
                      widget.emojisList.add(EmojiModel(
                          id: returnedEmojiData.id,
                          postId: widget.id,
                          username: widget.username,
                          userImage: widget.userImage,
                          emojiData: returnedEmojiData.emojiData));
                      reactionsCount++;
                    }
                    setState(() {
                      showReactionsBox = false;
                    });
                  },
                ))
                : Container()
          ],
        ),
      ),
    );
  }
}
