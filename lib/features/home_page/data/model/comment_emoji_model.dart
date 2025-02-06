class CommentEmojiModel {
  String? id;
  final String postId;
  final String commentId;
  final String emojiData;
  final String username;
  final String userImage;
  final String userEmail;

  CommentEmojiModel(
      {this.id,
        required this.postId,
        required this.commentId,
        required this.emojiData,
        required this.username,
        required this.userEmail,
        required this.userImage});

  static CommentEmojiModel fromMap(Map<String, dynamic> map) {
    CommentEmojiModel emojiModel = CommentEmojiModel(
        id: map['id'],
        commentId: map['commentId'],
        postId: map['postId'],
        emojiData: map['emojiData'],
        username: map['username'],
        userEmail: map['userEmail'],
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
      'userEmail': userEmail,
    };
  }
}
