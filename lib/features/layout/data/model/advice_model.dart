class AdviceModel {
  String? adviceId;
  String adviceText;
  String username;
  String userImage;
  String time;
  AdviceModel({this.adviceId, required this.adviceText, required this.username, required this.userImage, required this.time});

  static AdviceModel fromMap(Map<String, dynamic> map, String? id) {
    AdviceModel adviceModel = AdviceModel(
      adviceId: id,
      adviceText: map['adviceText'],
        username: map['username'],
      userImage: map['userImage'],
      time: map['time'],
    );
    return adviceModel;
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

List<AdviceModel> adviceModel = [];
