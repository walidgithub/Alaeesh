import 'package:last/features/home_page/data/model/comment_emoji_model.dart';


class CommentsModel {
  String? id;
  final String postId;
  final String username;
  final String userImage;
  final String userEmail;
  String? time;
  final String comment;
  final List<CommentEmojiModel> commentEmojiModel;
  CommentsModel(
      {this.id,
      required this.postId,
      required this.username,
      required this.userImage,
      required this.userEmail,
      this.time,
      required this.comment,
      required this.commentEmojiModel});

  static CommentsModel fromMap(Map<String, dynamic> map) {
    CommentsModel commentsModel = CommentsModel(
        id: map['id'],
        postId: map['postId'],
        username: map['username'],
        userImage: map['userImage'],
        userEmail: map['userEmail'],
        comment: map['comment'],
        commentEmojiModel: List.from(map['emojisList']).map((e)=>CommentEmojiModel.fromMap(e)).toList(),
        time: map['time']);
    return commentsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'username': username,
      'userImage': userImage,
      'userEmail': userEmail,
      'comment': comment,
      'emojisList': commentEmojiModel.map((e)=>e.toMap()).toList(),
      'time': time,
    };
  }
}
