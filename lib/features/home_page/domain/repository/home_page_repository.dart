import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/requests/add_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/send_notification_request.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../notifications/data/model/requests/get_post_data_request.dart';
import '../../data/model/home_page_model.dart';
import '../../data/model/requests/add_comment_emoji_request.dart';
import '../../data/model/requests/add_comment_request.dart';
import '../../data/model/requests/add_post_subscriber_request.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_comment_emoji_request.dart';
import '../../data/model/requests/delete_comment_request.dart';
import '../../data/model/requests/delete_emoji_request.dart';
import '../../data/model/requests/delete_post_subscriber_request.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/requests/get_posts_request.dart';
import '../../data/model/requests/get_subscribers_request.dart';
import '../../data/model/requests/update_comment_request.dart';
import '../../data/model/requests/update_post_request.dart';
import '../../data/model/subscribers_model.dart';

abstract class HomePageRepository {
  Future<Either<FirebaseFailure, void>> sendPostNotification(SendNotificationRequest sendNotificationRequest);
  Future<Either<FirebaseFailure, void>> sendGeneralNotification(SendNotificationRequest sendNotificationRequest);

  Future<Either<FirebaseFailure, void>> updatePost(UpdatePostRequest updatePostRequest);
  Future<Either<FirebaseFailure, void>> deletePost(String postId);
  Future<Either<FirebaseFailure, List<HomePageModel>>> searchPost(String postText);

  Future<Either<FirebaseFailure, void>> addComment(AddCommentRequest addCommentRequest);
  Future<Either<FirebaseFailure, void>> updateComment(UpdateCommentRequest updateCommentRequest);
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest);

  Future<Either<FirebaseFailure, void>> addPostSubscriber(AddPostSubscriberRequest addPostSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest);


  Future<Either<FirebaseFailure, void>> addSubscriber(AddSubscriberRequest addSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deleteSubscriber(
      DeleteSubscriberRequest deleteSubscriberRequest);
  Future<Either<FirebaseFailure, List<SubscribersModel>>> getSubscribers(
      GetSubscribersRequest getSubscribersRequest);

  Future<Either<FirebaseFailure, void>> addEmoji(AddEmojiRequest addEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);

  Future<Either<FirebaseFailure, void>> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest);

  Future<Either<FirebaseFailure, List<HomePageModel>>> getAllPosts(GetPostsRequest getPostsRequest);
  Future<Either<FirebaseFailure, List<HomePageModel>>> getHomePosts(GetPostsRequest getPostsRequest);

  Future<Either<FirebaseFailure, HomePageModel>> getPostData(
      GetPostDataRequest getPostDataRequest);
}