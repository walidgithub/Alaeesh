import 'package:last/features/home_page/data/model/comments_model.dart';

class UpdateCommentRequest {
  String postId;
  CommentsModel commentsModel;
  String lastTimeUpdate;
  UpdateCommentRequest({required this.postId,required this.commentsModel,required this.lastTimeUpdate});
}