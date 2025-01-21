class MessagesModel {
  String? id;
  String message;
  String username;
  String time;
  MessagesModel({this.id, required this.message, required this.username, required this.time});

  static MessagesModel fromMap(Map<String, dynamic> map) {
    MessagesModel messagesModel = MessagesModel(
      id: map['id'],
      username: map['username'],
      message: map['message'],
      time: map['time'],
    );
    return messagesModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'message': message,
      'time': time,
    };
  }
}