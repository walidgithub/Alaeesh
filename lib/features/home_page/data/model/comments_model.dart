import 'emoji_model.dart';

class CommentsModel {
  final int id;
  final int postId;
  final String username;
  final String userImage;
  final String time;
  final String comment;
  final List<EmojiModel> emojisList;
  int emojiDataCount;
  CommentsModel({required this.id, required this.postId, required this.username, required this.userImage, required this.time, required this.comment, required this.emojisList, required this.emojiDataCount});

  factory CommentsModel.fromMap(int id, int postId,
      String username, String userImage, String comment, String time, List<EmojiModel> emojisList, int emojiDataCount) {
    return CommentsModel(
        id: id,
        postId: postId,
        username: username,
        userImage: userImage,
        comment: comment,
        emojisList: emojisList,
        emojiDataCount: emojiDataCount,
        time: time);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'username': username,
      'userImage': userImage,
      'comment': comment,
      'emojisList': emojisList,
      'emojiDataCount': emojiDataCount,
      'time': time,
    };
  }

}