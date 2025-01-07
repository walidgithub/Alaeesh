import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/trending/data/data_source/trending_datasouce.dart';
import 'package:last/features/trending/data/model/requests/get_post_data_request.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';

class TrendingRepositoryImpl extends TrendingRepository {
  final TrendingDataSource _trendingDataSource;

  TrendingRepositoryImpl(this._trendingDataSource);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts() async {
    try {
      final result = await _trendingDataSource.getTopPosts();
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
    // TODO: implement getSuggestedUser
    throw UnimplementedError();
  }
}