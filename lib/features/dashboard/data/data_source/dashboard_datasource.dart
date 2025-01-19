import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/di/di.dart';
import '../../../layout/data/model/advice_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';

abstract class BaseDataSource {
  Future<void> updateUserPermissions(UserPermissionsModel userPermissionsModel);
  Future<List<AdviceModel>> getUserAdvices();
}

class DashboardDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<void> updateUserPermissions(UserPermissionsModel userPermissionsModel) async {
    try {
      final collection = firestore.collection('userPermissions');
      final querySnapshot = await collection
          .where('username', isEqualTo: userPermissionsModel.username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return;
      }

      // delete old one
      for (var doc in querySnapshot.docs) {
        await collection.doc(doc.id).delete();
      }

      // add new one
      final docRef = collection.doc();
      userPermissionsModel.id = docRef.id;
      await docRef.set(userPermissionsModel.toMap());
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<AdviceModel>> getUserAdvices() async {
    try {
      final collectionRef = firestore.collection('advices');
      final querySnapshot = await collectionRef.get();
      final adviceModels = querySnapshot.docs.map((doc) {
        return AdviceModel.fromMap(doc.data(), doc.id);
      }).toList();

      return adviceModels;
    } catch(e) {
      rethrow;
    }
  }
}