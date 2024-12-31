import '../comment_emoji_model.dart';

class AddCommentEmojiRequest {
  String postId;
  CommentEmojiModel commentEmojiModel;
  AddCommentEmojiRequest({required this.postId,required this.commentEmojiModel});
}