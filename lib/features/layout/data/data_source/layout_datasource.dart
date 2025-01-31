import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/layout/data/model/add_post_response.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../model/requests/send_advise_request.dart';

abstract class BaseDataSource {
  Future<AddPostResponse> addPost(PostModel postModel);
  Future<void> sendAdvice(SendAdviceRequest sendAdviceRequest);
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
  Future<void> sendAdvice(SendAdviceRequest sendAdviceRequest) async {
    try {
      final collection = firestore.collection('advices');
      final docRef = collection.doc();
      sendAdviceRequest.adviceId = docRef.id;
      await docRef.set(sendAdviceRequest.toMap());
    } catch (e) {
      rethrow;
    }
  }

}