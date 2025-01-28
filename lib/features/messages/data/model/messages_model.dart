class MessagesModel {
  String? id;
  String message;
  String username;
  String time;
  bool seen;
  MessagesModel({this.id, required this.message, required this.username, required this.time, required this.seen});

  static MessagesModel fromMap(Map<String, dynamic> map) {
    MessagesModel messagesModel = MessagesModel(
      id: map['id'],
      username: map['username'],
      message: map['message'],
      time: map['time'],
      seen: map['seen'],
    );
    return messagesModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'message': message,
      'time': time,
      'seen': seen,
    };
  }
}

List<MessagesModel> messagesModel = [];