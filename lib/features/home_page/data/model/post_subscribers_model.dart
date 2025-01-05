
class PostSubscribersModel {
  final String postId;
  final String username;
  final String userImage;
  PostSubscribersModel({required this.username, required this.userImage, required this.postId});

  static PostSubscribersModel fromMap(Map<String, dynamic> map) {
    PostSubscribersModel postSubscribersModel = PostSubscribersModel(
      username: map['username'],
      userImage: map['userImage'],
      postId: map['postId'],
    );
    return postSubscribersModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userImage': userImage,
      'postId': postId,
    };
  }
}