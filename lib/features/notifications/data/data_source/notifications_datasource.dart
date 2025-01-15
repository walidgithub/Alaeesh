import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/di/di.dart';
import '../model/notifications_model.dart';

abstract class BaseDataSource {
  Future<void> deleteNotification(int notificationId);
  Future<List<NotificationsModel>> getAllNotifications(int userId);
}

class NotificationsDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

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