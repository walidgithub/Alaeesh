import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';

class GetTopPostsUseCase extends FirebaseBaseUseCase{
  final TrendingRepository trendingRepository;

  GetTopPostsUseCase(this.trendingRepository);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> call(parameters) async {
    return await trendingRepository.getTopPosts(parameters);
  }
}