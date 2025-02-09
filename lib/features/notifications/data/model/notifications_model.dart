import '../../../home_page/data/model/post_model.dart';

class AlaeeshNotificationsModel {
  String? id;
  String notification;
  String username;
  String time;
  bool seen;
  AlaeeshNotificationsModel({
    this.id,
    required this.notification,
    required this.username,
    required this.time,
    required this.seen,
  });

  static AlaeeshNotificationsModel fromMap(Map<String, dynamic> map) {
    AlaeeshNotificationsModel alaeeshNotificationsModel = AlaeeshNotificationsModel(
      id: map['id'],
      username: map['username'],
      notification: map['notification'],
      time: map['time'],
      seen: map['seen'],
    );
    return alaeeshNotificationsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'notification': notification,
      'time': time,
      'seen': seen,
    };
  }
}

List<AlaeeshNotificationsModel> alaeeshNotificationsList = [];
