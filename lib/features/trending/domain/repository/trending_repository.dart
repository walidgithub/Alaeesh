import 'package:dartz/dartz.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../data/model/requests/get_post_data_request.dart';
import '../../data/model/requests/get_suggested_user_posts_request.dart';
import '../../data/model/suggested_user_model.dart';

abstract class TrendingRepository {
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts();
  Future<Either<FirebaseFailure, List<SuggestedUserModel>>> getSuggestedUsers();
  Future<Either<FirebaseFailure, List<HomePageModel>>> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest);
  Future<Either<FirebaseFailure, HomePageModel>> getPostData(GetPostDataRequest getPostDataRequest);
}