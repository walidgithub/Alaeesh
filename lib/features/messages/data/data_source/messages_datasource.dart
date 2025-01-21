import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/messages/data/model/messages_model.dart';

import '../../../../core/di/di.dart';
import '../model/requests/get_messages_request.dart';

abstract class BaseDataSource {
  Future<List<MessagesModel>> getUserMessages(
      GetMessagesRequest getMessagesRequest);
}

class MessagesDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<MessagesModel>> getUserMessages(
      GetMessagesRequest getMessagesRequest) async {
    List<MessagesModel> messagesList = [];
    try {
      var docs = await firestore
          .collection('messages')
          .where('username', isEqualTo: getMessagesRequest.username)
          .get();

      messagesList = docs.docs.map((doc) {
        var data = doc.data();
        return MessagesModel(
            id: doc.id,
            message: data['message'] ?? '',
            time: data['time'] ?? '',
            username: data['username'] ?? '');
      }).toList();

      return messagesList;
    } catch (e) {
      rethrow;
    }
  }
}
