import '../../../home_page/data/model/post_model.dart';

class AlaeeshNotificationsModel {
  String? id;
  String postId;
  String notification;
  String username;
  String userImage;
  String time;
  bool seen;
  AlaeeshNotificationsModel({
    this.id,
    required this.postId,
    required this.notification,
    required this.username,
    required this.userImage,
    required this.time,
    required this.seen,
  });

  static AlaeeshNotificationsModel fromMap(Map<String, dynamic> map) {
    AlaeeshNotificationsModel alaeeshNotificationsModel = AlaeeshNotificationsModel(
      id: map['id'],
      postId: map['postId'],
      username: map['username'],
      userImage: map['userImage'],
      notification: map['notification'],
      time: map['time'],
      seen: map['seen'],
    );
    return alaeeshNotificationsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'username': username,
      'userImage': userImage,
      'notification': notification,
      'time': time,
      'seen': seen,
    };
  }
}

List<AlaeeshNotificationsModel> alaeeshNotificationsList = [];
