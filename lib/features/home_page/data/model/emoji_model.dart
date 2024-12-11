class EmojiModel {
  final int id;
  final int postId;
  final String emojiData;
  final String username;
  final String userImage;

  EmojiModel({required this.id, required this.postId, required this.emojiData, required this.username, required this.userImage});

  factory EmojiModel.fromMap(int id, int postId, String data, String username, String userImage) {
    return EmojiModel(
      id: id,
      postId: postId,
      emojiData: data,
      username: username,
      userImage: userImage,
    );
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