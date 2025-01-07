import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';

class GetSuggestedUserPostsUseCase extends FirebaseBaseUseCase{
  final TrendingRepository trendingRepository;

  GetSuggestedUserPostsUseCase(this.trendingRepository);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> call(parameters) async {
    return await trendingRepository.getSuggestedUserPosts(parameters);
  }
}