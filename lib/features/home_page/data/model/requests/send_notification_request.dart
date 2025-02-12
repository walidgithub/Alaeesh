class SendNotificationRequest {
  String? id;
  String postId;
  String message;
  String postAuther;
  String userImage;
  String time;
  bool seen;
  SendNotificationRequest({this.id, required this.postId, required this.message, required this.postAuther, required this.userImage, required this.time, required this.seen});

  static SendNotificationRequest fromMap(Map<String, dynamic> map, String? id) {
    SendNotificationRequest sndReplyRequest = SendNotificationRequest(
      id: id,
      message: map['message'],
      postId: map['postId'],
      postAuther: map['postAuther'],
      userImage: map['userImage'],
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
      'postAuther': postAuther,
      'userImage': userImage,
      'time': time,
      'seen': seen,
    };
  }
}