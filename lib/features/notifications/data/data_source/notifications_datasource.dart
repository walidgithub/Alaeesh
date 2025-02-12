import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/notifications/data/model/requests/get_notifications_request.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../trending/data/model/requests/get_post_data_request.dart';
import '../model/notifications_model.dart';
import '../model/requests/update_notification_to_seeen_request.dart';

abstract class BaseDataSource {
  Future<List<AlaeeshNotificationsModel>> getUserNotifications(
      GetNotificationsRequest getNotificationsRequest);

  Future<void> updateNotificationToSeen(
      UpdateNotificationToSeenRequest updateNotificationToSeenRequest);

  Future<int> getUnSeenNotifications(GetNotificationsRequest getNotificationsRequest);
}

class NotificationsDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<AlaeeshNotificationsModel>> getUserNotifications(
      GetNotificationsRequest getNotificationsRequest) async {
    List<AlaeeshNotificationsModel> alaeeshNotificationsList = [];
    try {
      var docs = await firestore
          .collection('notifications')
          .where('username', isEqualTo: getNotificationsRequest.username)
          .get();

      alaeeshNotificationsList = docs.docs.map((doc) {
        var data = doc.data();
        return AlaeeshNotificationsModel(
            id: doc.id,
            postId: data['postId'] ?? '',
            notification: data['notification'] ?? '',
            time: data['time'] ?? '',
            username: data['username'] ?? '',
            userImage: data['userImage'] ?? '',
            seen: data['seen'] ?? false);
      }).toList();

      alaeeshNotificationsList.sort((a, b) => b.time.compareTo(a.time));

      return alaeeshNotificationsList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateNotificationToSeen(UpdateNotificationToSeenRequest updateNotificationToSeenRequest) async {
    try {
      final notificationRef = firestore
          .collection('notifications')
          .doc(updateNotificationToSeenRequest.id);

      await notificationRef.update({'seen': true});

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUnSeenNotifications(GetNotificationsRequest getNotificationsRequest) async {
    try {
      List<AlaeeshNotificationsModel> alaeeshNotificationsList = [];

      var docs = await firestore
          .collection('notifications')
          .where('username', isEqualTo: getNotificationsRequest.username)
          .where('seen', isEqualTo: false)
          .get();


      alaeeshNotificationsList = docs.docs.map((doc) {
        var data = doc.data();
        return AlaeeshNotificationsModel(
            id: doc.id,
            postId: data['postId'] ?? '',
            notification: data['notification'] ?? '',
            userImage: data['userImage'] ?? '',
            time: data['time'] ?? '',
            username: data['username'] ?? '',
            seen: data['seen'] ?? false);
      }).toList();
      return alaeeshNotificationsList.length;
    } catch (e) {
      rethrow;
    }
  }
}