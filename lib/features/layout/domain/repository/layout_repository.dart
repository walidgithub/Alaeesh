import 'package:dartz/dartz.dart';
import 'package:last/features/layout/data/model/notifications_model.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../data/model/add_post_response.dart';
import '../../data/model/advice_model.dart';
import '../../data/model/requests/send_advise_request.dart';

abstract class LayoutRepository {
  Future<Either<FirebaseFailure, AddPostResponse>> addPost(PostModel postModel);
  Future<Either<FirebaseFailure, void>> sendAdvice(SendAdviseRequest sendAdviseRequest);
  Future<Either<FirebaseFailure, void>> deleteNotification(int notificationId);
  Future<Either<FirebaseFailure, List<NotificationsModel>>> getAllNotifications(int userId);
}