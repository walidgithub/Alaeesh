import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/features/home_page/data/data_source/home_page_datasource.dart';
import 'package:last/features/trending/data/data_source/trending_datasource.dart';
import 'package:last/features/trending/data/model/requests/check_if_user_subscribed_request.dart';
import 'package:last/features/trending/data/model/requests/get_post_data_request.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/add_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/add_comment_request.dart';
import '../../../home_page/data/model/requests/add_emoji_request.dart';
import '../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../home_page/data/model/requests/update_comment_request.dart';
import '../../../home_page/data/model/requests/update_post_request.dart';
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

  @override
  Future<Either<FirebaseFailure, void>> updatePost(UpdatePostRequest updatePostRequest) async {
    try {
      final result = await _homePageDataSource.updatePost(updatePostRequest);
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
  Future<Either<FirebaseFailure, void>> addComment(AddCommentRequest addCommentRequest) async {
    try {
      final result = await _homePageDataSource.addComment(addCommentRequest);
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
  Future<Either<FirebaseFailure, void>> updateComment(UpdateCommentRequest updateCommentRequest) async {
    try {
      final result = await _homePageDataSource.updateComment(updateCommentRequest);
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
  Future<Either<FirebaseFailure, void>> addEmoji(AddEmojiRequest addEmojiRequest) async {
    try {
      final result = await _homePageDataSource.addEmoji(addEmojiRequest);
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
  Future<Either<FirebaseFailure, void>> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest) async {
    try {
      final result = await _homePageDataSource.addCommentEmoji(addCommentEmojiRequest);
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
  Future<Either<FirebaseFailure, void>> addPostSubscriber(AddPostSubscriberRequest addPostSubscriberRequest) async {
    try {
      final result = await _homePageDataSource.addPostSubscriber(addPostSubscriberRequest);
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
  Future<Either<FirebaseFailure, bool>> checkIfUserSubscribed(CheckIfUserSubscribedRequest checkIfUserSubscribedRequest) async {
    try {
      final result = await _trendingDataSource.checkIfUserSubscribed(checkIfUserSubscribedRequest);
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