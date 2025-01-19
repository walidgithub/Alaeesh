import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/layout/data/model/add_post_response.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../model/requests/send_advise_request.dart';

abstract class BaseDataSource {
  Future<AddPostResponse> addPost(PostModel postModel);
  Future<void> sendAdvice(SendAdviseRequest sendAdviseRequest);
  Future<UserPermissionsModel> getUserPermission(String username);
}

class LayoutDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<AddPostResponse> addPost(PostModel postModel) async {
    try {
      final collection = firestore.collection('posts');
      final docRef = collection.doc();
      postModel.id = docRef.id;
      await docRef.set(postModel.toMap());
      return AddPostResponse.fromMap({'postId': postModel.id});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendAdvice(SendAdviseRequest sendAdviseRequest) async {
    try {
      final collection = firestore.collection('advices');
      final docRef = collection.doc();
      sendAdviseRequest.adviceId = docRef.id;
      await docRef.set(sendAdviseRequest.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserPermissionsModel> getUserPermission(String username) async {
    try {
      final collection = firestore.collection('userPermissions');
      final querySnapshot = await collection
          .where('username', isEqualTo: username)
          .get();

      final doc = querySnapshot.docs.first;
      return UserPermissionsModel.fromMap(doc.data());
    } catch (e) {
      rethrow;
    }
  }

}