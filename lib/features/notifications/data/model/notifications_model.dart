import '../../../home_page/data/model/post_model.dart';

class NotificationsModel {
  final String id;
  final String username;
  PostModel postModel;
  NotificationsModel({
    required this.id,
    required this.username,
    required this.postModel,
  });

  static NotificationsModel fromMap(Map<String, dynamic> map) {
    NotificationsModel notificationsModel = NotificationsModel(
        id: map['id'],
        username: map['username'],
        postModel: map['postModel']);
    return notificationsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'postModel': postModel,
    };
  }
}

List<NotificationsModel> notificationsList = [];
