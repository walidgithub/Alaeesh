import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/features/home_page/data/data_source/home_page_datasource.dart';
import 'package:last/features/trending/data/data_source/trending_datasource.dart';
import 'package:last/features/trending/data/model/requests/get_post_data_request.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../model/requests/get_top_posts_request.dart';

class TrendingRepositoryImpl extends TrendingRepository {
  final TrendingDataSource _trendingDataSource;
  final HomePageDataSource _homePageDataSource;

  TrendingRepositoryImpl(this._trendingDataSource, this._homePageDataSource);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts(GetTopPostsRequest getTopPostsRequest) async {
    try {
      final result = await _trendingDataSource.getTopPosts(getTopPostsRequest);
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
  Future<Either<FirebaseFailure, List<SuggestedUserModel>>> getSuggestedUsers() async {
    try {
      final result = await _trendingDataSource.getSuggestedUsers();
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
  Future<Either<FirebaseFailure, HomePageModel>> getPostData(GetPostDataRequest getPostDataRequest) async {
    // TODO: implement getPostData
    throw UnimplementedError();
  }

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    try {
      final result = await _trendingDataSource.getSuggestedUserPosts(getSuggestedUserPostsRequest);
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
  Future<Either<FirebaseFailure, void>> addSubscriber(AddSubscriberRequest addSubscriberRequest) async {
    try {
      final result = await _homePageDataSource.addSubscriber(addSubscriberRequest);
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
  Future<Either<FirebaseFailure, void>> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest) async {
    try {
      final result = await _homePageDataSource.deleteSubscriber(deleteSubscriberRequest);
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