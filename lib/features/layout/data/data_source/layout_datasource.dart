import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/layout/data/model/add_post_response.dart';
import 'package:last/features/layout/data/model/notifications_model.dart';

import '../../../../core/di/di.dart';
import '../../../home_page/data/model/post_model.dart';

abstract class BaseDataSource {
  Future<AddPostResponse> addPost(PostModel postModel);
  Future<void> deleteNotification(int notificationId);
  Future<List<NotificationsModel>> getAllNotifications(int userId);
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

}