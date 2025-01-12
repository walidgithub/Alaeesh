import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import 'package:last/features/home_page/data/model/home_page_model.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_post_subscriber_request.dart';
import 'package:last/features/my_activities/data/datasource/my_activities_datasource.dart';
import 'package:last/features/my_activities/data/model/requests/get_my_activities_request.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../home_page/data/data_source/home_page_datasource.dart';
import '../../domain/repository/my_activities_repository.dart';

class MyActivitiesRepositoryImpl extends MyActivitiesRepository{
  final GetMyActivitiesDataSource _getMyActivitiesDataSource;
  final HomePageDataSource _homePageDataSource;

  MyActivitiesRepositoryImpl(this._getMyActivitiesDataSource,
      this._homePageDataSource);

  @override
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest) async {
    try {
      final result = await _homePageDataSource.deleteComment(deleteCommentRequest);
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
  Future<Either<FirebaseFailure, void>> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest) async {
    try {
      final result = await _homePageDataSource.deleteCommentEmoji(deleteCommentEmojiRequest);
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
  Future<Either<FirebaseFailure, void>> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest) async {
    try {
      final result = await _homePageDataSource.deleteEmoji(deleteEmojiRequest);
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
  Future<Either<FirebaseFailure, void>> deletePost(String postId) async {
    try {
      final result = await _homePageDataSource.deletePost(postId);
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
  Future<Either<FirebaseFailure, void>> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest) async {
    try {
      final result = await _homePageDataSource.deletePostSubscriber(deletePostSubscriberRequest);
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
  Future<Either<FirebaseFailure, List<HomePageModel>>> getMyActivities(GetMyActivitiesRequest getMyActivitiesRequest) async {
    try {
      final result = await _getMyActivitiesDataSource.getMyActivities(getMyActivitiesRequest);
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