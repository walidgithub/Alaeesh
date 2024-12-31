import 'package:last/features/home_page/data/model/emoji_model.dart';

class AddEmojiRequest {
  String postId;
  EmojiModel emojiModel;
  AddEmojiRequest({required this.postId,required this.emojiModel});
}