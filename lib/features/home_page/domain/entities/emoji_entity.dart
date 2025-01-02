import 'package:last/core/utils/constant/app_strings.dart';

class EmojiEntity {
  final String id;
  final String emojiData;

  EmojiEntity({required this.id, required this.emojiData});
}

List<EmojiEntity> emojisData = [
  EmojiEntity(id: "0", emojiData: AppStrings.skip),
  EmojiEntity(id: "1", emojiData: "😂"),
  EmojiEntity(id: "2", emojiData: "😅"),
  EmojiEntity(id: "3", emojiData: "😏"),
  EmojiEntity(id: "4", emojiData: "🤔"),
];