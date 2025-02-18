import 'package:dartz/dartz.dart';
import 'package:last/features/dashboard/data/model/requests/send_reply_request.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../layout/data/model/advice_model.dart';
import '../../data/model/user_model.dart';

abstract class DashboardRepository {
  Future<Either<FirebaseFailure, List<AdviceModel>>> getUserAdvices();
  Future<Either<FirebaseFailure, List<HomePageModel>>> getAllPosts(GetPostsRequest getPostsRequest);
  Future<Either<FirebaseFailure, void>> sendReply(SendReplyRequest sendReplyRequest);
  Future<Either<FirebaseFailure, void>> addUser(AllowedUserModel allowedUserModel);

  Future<Either<FirebaseFailure, void>> deletePost(String postId);
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest);
  Future<Either<FirebaseFailure, void>> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest);
}