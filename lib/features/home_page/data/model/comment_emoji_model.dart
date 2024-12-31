class CommentEmojiModel {
  String? id;
  final String postId;
  final String commentId;
  final String emojiData;
  final String username;
  final String userImage;

  CommentEmojiModel(
      {this.id,
        required this.postId,
        required this.commentId,
        required this.emojiData,
        required this.username,
        required this.userImage});

  static CommentEmojiModel fromMap(Map<String, dynamic> map) {
    CommentEmojiModel emojiModel = CommentEmojiModel(
        id: map['id'],
        commentId: map['commentId'],
        postId: map['postId'],
        emojiData: map['emojiData'],
        username: map['username'],
        userImage: map['userImage']);
    return emojiModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'commentId': commentId,
      'id': id,
      'emojiData': emojiData,
      'username': username,
      'userImage': userImage,
    };
  }
}
