class SuggestedUserModel {
  String userImage;
  String userName;
  int postsCount;
  int goodEmojis;
  SuggestedUserModel({required this.goodEmojis, required this.postsCount, required this.userImage, required this.userName});
}