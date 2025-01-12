import 'package:dartz/dartz.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
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
import '../../data/model/requests/check_if_user_subscribed_request.dart';
import '../../data/model/requests/get_post_data_request.dart';
import '../../data/model/requests/get_suggested_user_posts_request.dart';
import '../../data/model/requests/get_top_posts_request.dart';
import '../../data/model/suggested_user_model.dart';

abstract class TrendingRepository {
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts(GetTopPostsRequest getTopPostsRequest);
  Future<Either<FirebaseFailure, List<SuggestedUserModel>>> getSuggestedUsers();
  Future<Either<FirebaseFailure, List<HomePageModel>>> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest);
  Future<Either<FirebaseFailure, void>> addSubscriber(AddSubscriberRequest addSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deleteSubscriber(
      DeleteSubscriberRequest deleteSubscriberRequest);

  Future<Either<FirebaseFailure, bool>> checkIfUserSubscribed(CheckIfUserSubscribedRequest checkIfUserSubscribedRequest);

  Future<Either<FirebaseFailure, void>> updatePost(UpdatePostRequest updatePostRequest);
  Future<Either<FirebaseFailure, void>> deletePost(String postId);

  Future<Either<FirebaseFailure, void>> addComment(AddCommentRequest addCommentRequest);
  Future<Either<FirebaseFailure, void>> updateComment(UpdateCommentRequest updateCommentRequest);
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest);

  Future<Either<FirebaseFailure, void>> addPostSubscriber(AddPostSubscriberRequest addPostSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest);

  Future<Either<FirebaseFailure, void>> addEmoji(AddEmojiRequest addEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);

  Future<Either<FirebaseFailure, void>> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest);
}