class EmojiEntity {
  final String id;
  final String emojiData;

  EmojiEntity({required this.id, required this.emojiData});
}

List<EmojiEntity> emojisData = [
  EmojiEntity(id: "0", emojiData: " تـراجـع  "),
  EmojiEntity(id: "1", emojiData: "😂"),
  EmojiEntity(id: "2", emojiData: "😅"),
  EmojiEntity(id: "3", emojiData: "😏"),
  EmojiEntity(id: "4", emojiData: "🤔"),
];