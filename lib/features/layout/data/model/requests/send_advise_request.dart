class SendAdviceRequest {
  String? adviceId;
  String adviceText;
  String username;
  String userImage;
  String time;
  SendAdviceRequest({this.adviceId, required this.adviceText, required this.username, required this.userImage, required this.time});

  static SendAdviceRequest fromMap(Map<String, dynamic> map) {
    SendAdviceRequest sendAdviceRequest = SendAdviceRequest(
      adviceId: map['adviceId'],
      adviceText: map['adviceText'],
      username: map['username'],
      userImage: map['userImage'],
      time: map['time'],
    );
    return sendAdviceRequest;
  }

  Map<String, dynamic> toMap() {
    return {
      'adviceId': adviceId,
      'adviceText': adviceText,
      'username': username,
      'userImage': userImage,
      'time': time,
    };
  }
}