import 'package:last/features/home_page/data/model/comments_model.dart';

class AddCommentRequest {
  String postId;
  CommentsModel commentsModel;
  String lastTimeUpdate;
  AddCommentRequest({required this.postId,required this.commentsModel,required this.lastTimeUpdate});
}