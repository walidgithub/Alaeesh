
class SubscribersModel {
  String? id;
  final String username;
  final String postAuther;
  SubscribersModel({this.id, required this.username, required this.postAuther});

  static SubscribersModel fromMap(Map<String, dynamic> map) {
    SubscribersModel subscribersModel = SubscribersModel(
      username: map['username'],
      postAuther: map['postAuther'],
      id: map['id'],
    );
    return subscribersModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'postAuther': postAuther,
      'id': id,
    };
  }
}