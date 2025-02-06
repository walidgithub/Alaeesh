
class PostSubscribersModel {
  final String postId;
  final String username;
  final String userImage;
  final String userEmail;
  PostSubscribersModel({required this.username, required this.userEmail, required this.userImage, required this.postId});

  static PostSubscribersModel fromMap(Map<String, dynamic> map) {
    PostSubscribersModel postSubscribersModel = PostSubscribersModel(
      username: map['username'],
      userImage: map['userImage'],
      userEmail: map['userEmail'],
      postId: map['postId'],
    );
    return postSubscribersModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userImage': userImage,
      'userEmail': userEmail,
      'postId': postId,
    };
  }
}