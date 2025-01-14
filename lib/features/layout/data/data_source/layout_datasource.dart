import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/layout/data/model/add_post_response.dart';
import 'package:last/features/layout/data/model/notifications_model.dart';

import '../../../../core/di/di.dart';
import '../../../home_page/data/model/post_model.dart';
import '../model/advice_model.dart';
import '../model/requests/send_advise_request.dart';

abstract class BaseDataSource {
  Future<AddPostResponse> addPost(PostModel postModel);
  Future<void> deleteNotification(int notificationId);
  Future<List<NotificationsModel>> getAllNotifications(int userId);
  Future<void> sendAdvice(SendAdviseRequest sendAdviseRequest);
}

class LayoutDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<AddPostResponse> addPost(PostModel postModel) async {
    try {
      final collection = FirebaseFirestore.instance.collection('posts');
      final docRef = collection.doc();
      postModel.id = docRef.id;
      await docRef.set(postModel.toMap());
      return AddPostResponse.fromMap({'postId': postModel.id});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    try {

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NotificationsModel>> getAllNotifications(int userId) async {
    try {
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendAdvice(SendAdviseRequest sendAdviseRequest) async {
    try {
      final collection = FirebaseFirestore.instance.collection('advices');
      final docRef = collection.doc();
      sendAdviseRequest.adviceId = docRef.id;
      await docRef.set(sendAdviseRequest.toMap());
    } catch (e) {
      rethrow;
    }
  }

}