import 'package:last/features/home_page/data/model/comments_model.dart';

class AddCommentRequest {
  String postId;
  CommentsModel commentsModel;
  AddCommentRequest({required this.postId,required this.commentsModel});
}