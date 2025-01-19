import 'package:dartz/dartz.dart';

import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/delete_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../layout/data/model/advice_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';

abstract class DashboardRepository {
  Future<Either<FirebaseFailure, void>> updateUserPermissions(UserPermissionsModel userPermissionsModel);
  Future<Either<FirebaseFailure, List<AdviceModel>>> getUserAdvices();
  Future<Either<FirebaseFailure, List<HomePageModel>>> getAllPosts(GetPostsRequest getPostsRequest);

  Future<Either<FirebaseFailure, void>> deletePost(String postId);
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest);
  Future<Either<FirebaseFailure, void>> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest);
}