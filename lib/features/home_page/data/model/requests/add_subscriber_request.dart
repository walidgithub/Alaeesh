class AddSubscriberRequest {
  String? id;
  final String username;
  final String postAuther;
  AddSubscriberRequest({this.id, required this.username, required this.postAuther});

  static AddSubscriberRequest fromMap(Map<String, dynamic> map) {
    AddSubscriberRequest subscribersModel = AddSubscriberRequest(
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