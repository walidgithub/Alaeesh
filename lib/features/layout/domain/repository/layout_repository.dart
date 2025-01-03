import 'package:dartz/dartz.dart';
import 'package:last/features/layout/data/model/notifications_model.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/post_model.dart';

abstract class LayoutRepository {
  Future<Either<FirebaseFailure, void>> addPost(PostModel postModel);
  Future<Either<FirebaseFailure, void>> deleteNotification(int notificationId);
  Future<Either<FirebaseFailure, List<NotificationsModel>>> getAllNotifications(int userId);
}