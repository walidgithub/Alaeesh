class EmojiEntity {
  final int id;
  final String emojiData;

  EmojiEntity({required this.id, required this.emojiData});
}

List<EmojiEntity> emojisData = [
  EmojiEntity(id: 1, emojiData: "😂"),
  EmojiEntity(id: 2, emojiData: "😅"),
  EmojiEntity(id: 3, emojiData: "😏"),
  EmojiEntity(id: 4, emojiData: "🤔"),
];