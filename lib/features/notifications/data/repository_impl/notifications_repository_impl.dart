import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import 'package:last/features/notifications/data/model/requests/get_notifications_request.dart';
import 'package:last/features/notifications/data/model/requests/update_notification_to_seeen_request.dart';
import 'package:last/features/trending/data/model/requests/get_post_data_request.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../domain/repository/notifications_repository.dart';
import '../data_source/notifications_datasource.dart';
import '../model/notifications_model.dart';

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsDataSource _notificationsDataSource;

  NotificationsRepositoryImpl(this._notificationsDataSource);

  @override
  Future<Either<FirebaseFailure, int>> getUnSeenNotifications(GetNotificationsRequest getNotificationsRequest) async {
    try {
      final result =
      await _notificationsDataSource.getUnSeenNotifications(getNotificationsRequest);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<AlaeeshNotificationsModel>>> getUserNotifications(GetNotificationsRequest getNotificationsRequest) async {
    try {
      final result =
      await _notificationsDataSource.getUserNotifications(getNotificationsRequest);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateNotificationToSeen(UpdateNotificationToSeenRequest updateNotificationToSeenRequest) async {
    try {
      final result =
      await _notificationsDataSource.updateNotificationToSeen(updateNotificationToSeenRequest);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }
  
}