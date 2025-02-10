class SendNotificationRequest {
  String? id;
  String postId;
  String message;
  String username;
  String time;
  bool seen;
  SendNotificationRequest({this.id, required this.postId, required this.message, required this.username, required this.time, required this.seen});

  static SendNotificationRequest fromMap(Map<String, dynamic> map, String? id) {
    SendNotificationRequest sndReplyRequest = SendNotificationRequest(
      id: id,
      message: map['message'],
      postId: map['postId'],
      username: map['username'],
      time: map['time'],
      seen: map['seen'],
    );
    return sndReplyRequest;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'message': message,
      'username': username,
      'time': time,
      'seen': seen,
    };
  }
}