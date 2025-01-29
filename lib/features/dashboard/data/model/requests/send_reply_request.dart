class SendReplyRequest {
  String? id;
  String message;
  String username;
  String time;
  bool seen;
  SendReplyRequest({this.id, required this.message, required this.username, required this.time, required this.seen});

  static SendReplyRequest fromMap(Map<String, dynamic> map, String? id) {
    SendReplyRequest sndReplyRequest = SendReplyRequest(
      id: id,
      message: map['message'],
      username: map['username'],
      time: map['time'],
      seen: map['seen'],
    );
    return sndReplyRequest;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'username': username,
      'time': time,
      'seen': seen,
    };
  }

}