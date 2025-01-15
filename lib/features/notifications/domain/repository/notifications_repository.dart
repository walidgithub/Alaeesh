import 'package:dartz/dartz.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/notifications_model.dart';

abstract class NotificationsRepository {
  Future<Either<FirebaseFailure, void>> deleteNotification(int notificationId);
  Future<Either<FirebaseFailure, List<NotificationsModel>>> getAllNotifications(int userId);
}