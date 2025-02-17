import 'package:last/features/home_page/data/model/post_subscribers_model.dart';

import 'comments_model.dart';
import 'emoji_model.dart';

class PostModel {
  String? id;
  final String postAlsha;
  final String username;
  final String userImage;
  final String userEmail;
  final List<EmojiModel> emojisList;
  final List<CommentsModel> commentsList;
  String? time;
  final String lastUpdateTime;
  final List<PostSubscribersModel> postSubscribersList;
  PostModel(
      {this.id,
        required this.postAlsha,
        required this.username,
        required this.userImage,
        required this.userEmail,
        required this.emojisList,
        required this.commentsList,
        required this.postSubscribersList,
        required this.lastUpdateTime,
        this.time});

  static PostModel fromMap(Map<String, dynamic> map) {
    PostModel postModel = PostModel(
        id: map['id'],
        postAlsha: map['postAlsha'],
        username: map['username'],
        userImage: map['userImage'],
        userEmail: map['userEmail'],
        lastUpdateTime: map['lastUpdateTime'],
        emojisList: List.from(map['emojisList']).map((e)=>EmojiModel.fromMap(e)).toList(),
        commentsList: List.from(map['commentsList']).map((e)=>CommentsModel.fromMap(e)).toList(),
        postSubscribersList: List.from(map['subscribersList']).map((e)=>PostSubscribersModel.fromMap(e)).toList(),
        time: map['time']);
    return postModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postAlsha': postAlsha,
      'username': username,
      'userImage': userImage,
      'userEmail': userEmail,
      'lastUpdateTime': lastUpdateTime,
      'emojisList': emojisList.map((e)=>e.toMap()).toList(),
      'commentsList': commentsList.map((e)=>e.toMap()).toList(),
      'subscribersList': postSubscribersList.map((e)=>e.toMap()).toList(),
      'time': time,
    };
  }
}