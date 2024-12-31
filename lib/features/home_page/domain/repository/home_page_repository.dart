import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/data/model/requests/add_emoji_request.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/requests/add_comment_emoji_request.dart';
import '../../data/model/requests/add_comment_request.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_comment_emoji_request.dart';
import '../../data/model/requests/delete_comment_request.dart';
import '../../data/model/requests/delete_emoji_request.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/requests/update_comment_request.dart';
import '../../data/model/requests/update_post_request.dart';

abstract class HomePageRepository {
  Future<Either<FirebaseFailure, void>> updatePost(UpdatePostRequest updatePostRequest);
  Future<Either<FirebaseFailure, void>> deletePost(String postId);

  Future<Either<FirebaseFailure, void>> addComment(AddCommentRequest AddCommentRequest);
  Future<Either<FirebaseFailure, void>> updateComment(UpdateCommentRequest updateCommentRequest);
  Future<Either<FirebaseFailure, void>> deleteComment(DeleteCommentRequest deleteCommentRequest);

  Future<Either<FirebaseFailure, void>> addSubscriber(AddSubscriberRequest addSubscriberRequest);
  Future<Either<FirebaseFailure, void>> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest);

  Future<Either<FirebaseFailure, void>> addEmoji(AddEmojiRequest addEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);

  Future<Either<FirebaseFailure, void>> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest);
  Future<Either<FirebaseFailure, void>> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest);

  Future<Either<FirebaseFailure, List<PostModel>>> getAllPosts();
  Future<Either<FirebaseFailure, List<PostModel>>> getTopPosts();
}