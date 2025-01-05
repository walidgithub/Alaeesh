import '../subscribers_model.dart';

class DeleteSubscriberRequest {
  String? id;
  final String username;
  final String postAuther;
  DeleteSubscriberRequest({this.id, required this.username, required this.postAuther});
}