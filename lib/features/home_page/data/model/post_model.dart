import 'package:alaeeeesh/features/home_page/data/model/emoji_model.dart';

import '../../../../core/utils/constant/app_assets.dart';
import 'comments_model.dart';

class PostModel {
  final int id;
  final String postAlsha;
  final String username;
  final String userImage;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  final String time;
  int emojiDataCount;
  PostModel(
      {required this.id,
      required this.postAlsha,
      required this.username,
      required this.userImage,
      required this.emojisList,
      required this.commentsList,
  required this.emojiDataCount,
      required this.time});

  factory PostModel.fromMap(int id, String postAlsha,
      String username, String userImage, List<EmojiModel> emojisList, List<CommentsModel> commentsList, int emojiDataCount, String time) {
    return PostModel(
        id: id,
        postAlsha: postAlsha,
        username: username,
        userImage: userImage,
        emojisList: emojisList,
        commentsList: commentsList,
        emojiDataCount: emojiDataCount,
        time: time);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postAlsha': postAlsha,
      'username': username,
      'userImage': userImage,
      'emojisList': emojisList,
      'commentsList': commentsList,
      'emojiDataCount': emojiDataCount,
      'time': time,
    };
  }
}
List<PostModel> postModel = [
  PostModel(
      id: 1,
      emojiDataCount: 0,
      postAlsha:
      " الشة رقم 1 الشة رقم 1الشة رقم 1الشة رقم 1 الشة رقم 1 الشة رقم 1 الشة رقم 1",
      username: "walid111",
      commentsList: [CommentsModel(id: 1, postId: 1, username: "walid2222", userImage: AppAssets.profile.toString(), time: "2h", comment: "التعليقاتتتتتتتتت",emojiDataCount: 0,emojisList: [])],
      userImage: AppAssets.profile.toString(),
      emojisList: [],
      time: "2h"),
  PostModel(
      id: 2,
      emojiDataCount: 0,
      postAlsha:
      " الشة رقم 2 الشة رقم 2الشة رقم 2الشة رقم 2 الشة رقم 2 الشة رقم 2 الشة رقم 2",
      username: "walid2222",
      commentsList: [],
      userImage: AppAssets.profile.toString(),
      emojisList: [],
      time: "3h"),
];

