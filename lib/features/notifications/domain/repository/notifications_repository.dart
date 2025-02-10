import 'package:dartz/dartz.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../trending/data/model/requests/get_post_data_request.dart';
import '../../data/model/notifications_model.dart';
import '../../data/model/requests/get_notifications_request.dart';
import '../../data/model/requests/update_notification_to_seeen_request.dart';

abstract class NotificationsRepository {
  Future<Either<FirebaseFailure, List<AlaeeshNotificationsModel>>> getUserNotifications(
      GetNotificationsRequest getNotificationsRequest);

  Future<Either<FirebaseFailure, PostModel>> getPostData(
      GetPostDataRequest getPostDataRequest);

  Future<Either<FirebaseFailure, void>> updateNotificationToSeen(UpdateNotificationToSeenRequest updateNotificationToSeenRequest);

  Future<Either<FirebaseFailure, int>> getUnSeenNotifications(GetNotificationsRequest getNotificationsRequest);
}