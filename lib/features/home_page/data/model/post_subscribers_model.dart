
import '../../../welcome/data/model/user_model.dart';

class SubscribersModel {
  final String postId;
  final String username;
  final String userImage;
  SubscribersModel({required this.username, required this.userImage, required this.postId});

  static SubscribersModel fromMap(Map<String, dynamic> map) {
    SubscribersModel subscribersModel = SubscribersModel(
      username: map['username'],
      userImage: map['userImage'],
      postId: map['postId'],
    );
    return subscribersModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userImage': userImage,
      'postId': postId,
    };
  }
}