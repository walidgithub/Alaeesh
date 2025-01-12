import 'package:last/features/home_page/data/model/post_model.dart';

class HomePageModel {
  final PostModel postModel;
  final bool userSubscribed;

  HomePageModel({required this.postModel, required this.userSubscribed});
}

List<HomePageModel> homePageModel = [];
List<HomePageModel> trendingModel = [];
