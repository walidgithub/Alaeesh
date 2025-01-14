class SendAdviseRequest {
  String? adviceId;
  String adviceText;
  SendAdviseRequest({this.adviceId, required this.adviceText});

  static SendAdviseRequest fromMap(Map<String, dynamic> map) {
    SendAdviseRequest sendAdviseRequest = SendAdviseRequest(
      adviceId: map['adviceId'],
      adviceText: map['adviceText'],);
    return sendAdviseRequest;
  }

  Map<String, dynamic> toMap() {
    return {
      'adviceId': adviceId,
      'adviceText': adviceText,
    };
  }
}