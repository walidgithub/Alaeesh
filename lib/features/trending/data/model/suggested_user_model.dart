class SuggestedUserModel {
  String userImage;
  String userName;
  String userEmail;
  int subscriptionsCount;
  SuggestedUserModel({required this.subscriptionsCount, required this.userImage, required this.userEmail, required this.userName});
}

List<SuggestedUserModel> suggestedUserModel = [];