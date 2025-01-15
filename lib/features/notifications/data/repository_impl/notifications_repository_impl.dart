import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../domain/repository/notifications_repository.dart';
import '../data_source/notifications_datasource.dart';
import '../model/notifications_model.dart';

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsDataSource _notificationsDataSource;

  NotificationsRepositoryImpl(this._notificationsDataSource);

  @override
  Future<Either<FirebaseFailure, void>> deleteNotification(int notificationId) async {
    try {
      final result = await _notificationsDataSource.deleteNotification(notificationId);
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
  Future<Either<FirebaseFailure, List<NotificationsModel>>> getAllNotifications(int userId) async {
    try {
      final result = await _notificationsDataSource.getAllNotifications(userId);
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