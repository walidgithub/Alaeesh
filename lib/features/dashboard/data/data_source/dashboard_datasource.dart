import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/di/di.dart';
import '../../../layout/data/model/advice_model.dart';
import '../model/requests/send_reply_request.dart';
import '../model/user_model.dart';

abstract class BaseDataSource {
  Future<List<AdviceModel>> getUserAdvices();
  Future<void> sendReply(SendReplyRequest sendReplyRequest);
  Future<void> addUSer(AllowedUserModel allowedUserModel);
}

class DashboardDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<AdviceModel>> getUserAdvices() async {
    try {
      final collectionRef = firestore.collection('advices');
      final querySnapshot = await collectionRef.get();
      final adviceModels = querySnapshot.docs.map((doc) {
        return AdviceModel.fromMap(doc.data(), doc.id);
      }).toList();

      adviceModels.sort((a, b) => b.time.compareTo(a.time));

      return adviceModels;
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> sendReply(SendReplyRequest sendReplyRequest) async {
    try {
      final collection = firestore.collection('messages');
      final docRef = collection.doc();
      sendReplyRequest.id = docRef.id;
      await docRef.set(sendReplyRequest.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addUSer(AllowedUserModel allowedUserModel) async {
    try {
      final collection = firestore.collection('allowedUsers');
      final docRef = collection.doc();
      allowedUserModel.id = docRef.id;
      await docRef.set(allowedUserModel.toMap());
    } catch (e) {
      rethrow;
    }
  }
}