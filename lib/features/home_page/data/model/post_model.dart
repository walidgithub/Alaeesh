import 'package:alaeeeesh/features/home_page/data/model/emoji_model.dart';

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
