import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../model/requests/get_post_data_request.dart';

abstract class BaseDataSource {
  Future<List<HomePageModel>> getTopPosts();
  Future<List<SuggestedUserModel>> getSuggestedUsers();
  Future<List<HomePageModel>> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest);
  Future<HomePageModel> getPostData(GetPostDataRequest getPostDataRequest);
}

class TrendingDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<HomePageModel>> getTopPosts() async {
    try {
     return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SuggestedUserModel>> getSuggestedUsers() async {
    try {
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HomePageModel> getPostData(GetPostDataRequest getPostDataRequest) async {
    HomePageModel? homePageModel;
    try {
      return homePageModel!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomePageModel>> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    try {
      return [];
    } catch (e) {
      rethrow;
    }
  }
}