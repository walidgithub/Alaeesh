import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/constant/app_assets.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/constant/app_typography.dart';
import '../../../../../core/utils/style/app_colors.dart';
import '../../../../../core/utils/ui_components/custom_divider.dart';
import '../../../data/model/emoji_model.dart';

class ReactionsBottomSheet extends StatefulWidget {
  double statusBarHeight;
  List<EmojiModel> emojisList;
  ReactionsBottomSheet(
      {super.key, required this.statusBarHeight, required this.emojisList});

  @override
  State<ReactionsBottomSheet> createState() => _ReactionsBottomSheetState();
}

class _ReactionsBottomSheetState extends State<ReactionsBottomSheet> {
  var tabsList = [];
  var selectedList = [];
  List<bool> selected = [];

  @override
  void initState() {
    tabsList.add(EmojiModel(postId: "0",id: "0",emojiData: "الـكـل",username: "",userImage: "",userEmail: ""));
    tabsList.addAll(widget.emojisList);
    selectedList.addAll(widget.emojisList);
    for (var n in tabsList) {
      selected.add(false);
    }
    selected[0] = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.sizeOf(context).height - widget.statusBarHeight,
        padding: EdgeInsets.all(20.h),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: AppColors.cWhite,
            border: Border.all(color: AppColors.cTitle, width: 1.5.w),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomDivider(),
            const Divider(
              color: AppColors.grey,
            ),
            SizedBox(height: AppConstants.heightBetweenElements),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                      width: MediaQuery.sizeOf(context).width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Bounceable(
                              onTap: () {
                                setState(() {
                                  for (int n = 0; n < selected.length; n++) {
                                    selected[n] = false;
                                  }
                                  selected[index] = true;
                                });
                                selectedList.clear();
                                if (selected[0]) {
                                  selectedList.addAll(widget.emojisList);
                                } else {
                                  print(tabsList[index].emojiData);
                                  selectedList.addAll(widget.emojisList.where((element) => element.id == tabsList[index].id));
                                }

                              },
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            tabsList[index].emojiData,
                                            style: AppTypography.kLight20,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          tabsList[index].emojiData != "الـكـل" ? Text(widget.emojisList.where((element) => element.emojiData == tabsList[index].emojiData).length.toString(),style: AppTypography.kLight12,) : Text("")
                                        ],
                                      ),
                                      selected[index] ? const CustomDivider() : SizedBox(
                                        height: 5.h,
                                        width: 60.w,
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 5.w,)
                                ],
                              ),
                            );
                          },
                          itemCount: tabsList.length),
                    ),
                    SizedBox(
                      height: AppConstants.moreHeightBetweenElements,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 25.r,
                                          backgroundColor: AppColors.cWhite,
                                          child: Container(
                                              padding: EdgeInsets.all(2.w),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.cTitle,
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2.w,
                                                        color: AppColors.cTitle,
                                                      ),
                                                  errorWidget: (context, url, error) =>
                                                      Image.asset(AppAssets.profile),
                                                  imageUrl: selectedList[index].userImage,
                                                ),
                                              ))),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        selectedList[index].username,
                                        style: AppTypography.kLight16,
                                      ),],
                                  ),
                                  Text(
                                    selectedList[index].emojiData,
                                    style: AppTypography.kLight20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          );
                        },
                        itemCount: selectedList.length)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
