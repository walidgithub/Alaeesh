import 'package:dartz/dartz.dart';

import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';

abstract class TrendingRepository {
  Future<Either<FirebaseFailure, List<HomePageModel>>> getTopPosts(GetPostsRequest getPostsRequest);
}