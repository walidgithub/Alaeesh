import 'package:last/features/home_page/data/model/emoji_model.dart';

class AddEmojiRequest {
  String postId;
  EmojiModel emojiModel;
  String lastTimeUpdate;
  AddEmojiRequest({required this.postId,required this.emojiModel,required this.lastTimeUpdate});
}