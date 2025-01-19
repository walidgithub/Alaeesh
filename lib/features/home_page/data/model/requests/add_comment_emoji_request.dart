import '../comment_emoji_model.dart';

class AddCommentEmojiRequest {
  String postId;
  CommentEmojiModel commentEmojiModel;
  String lastTimeUpdate;
  AddCommentEmojiRequest({required this.postId,required this.commentEmojiModel,required this.lastTimeUpdate});
}