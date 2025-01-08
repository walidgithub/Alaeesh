class SuggestedUserModel {
  String userImage;
  String userName;
  int subscriptionsCount;
  SuggestedUserModel({required this.subscriptionsCount, required this.userImage, required this.userName});
}

List<SuggestedUserModel> suggestedUserModel = [];