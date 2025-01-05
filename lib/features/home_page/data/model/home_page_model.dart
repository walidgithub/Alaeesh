import 'package:last/features/home_page/data/model/post_model.dart';

class HomePageModel {
  final PostModel postModel;
  final bool userSubscribed;

  HomePageModel({required this.postModel, required this.userSubscribed});

  Map<String, dynamic> toMap() {
    return {
      'postModel': postModel.toMap(),
      'userSubscribed': userSubscribed,
    };
  }

  static HomePageModel fromMap(Map<String, dynamic> map) {
    return HomePageModel(
      postModel: PostModel.fromMap(map['postModel']),
      userSubscribed: map['userSubscribed'],
    );
  }
}

List<HomePageModel> homePageModel = [];
