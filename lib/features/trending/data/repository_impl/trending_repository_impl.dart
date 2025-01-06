import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/features/trending/data/data_source/trending_datasouce.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/data_source/home_page_datasource.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';

class TrendingRepositoryImpl extends TrendingRepository {
  final TrendingDataSource _trendingDataSource;

  TrendingRepositoryImpl(this._trendingDataSource);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts(GetPostsRequest getPostsRequest) async {
    try {
      final result = await _trendingDataSource.getTopPosts(getPostsRequest);
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