class EmojiModel {
  String? id;
  final String postId;
  final String emojiData;
  final String username;
  final String userImage;

  EmojiModel(
      {this.id,
      required this.postId,
      required this.emojiData,
      required this.username,
      required this.userImage});

  static EmojiModel fromMap(Map<String, dynamic> map) {
    EmojiModel emojiModel = EmojiModel(
        id: map['id'],
        postId: map['postId'],
        emojiData: map['emojiData'],
        username: map['username'],
        userImage: map['userImage']);
    return emojiModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'id': id,
      'emojiData': emojiData,
      'username': username,
      'userImage': userImage,
    };
  }
}
