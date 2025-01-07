import 'package:dartz/dartz.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../repository/trending_repository.dart';

class GetSuggestedUsersUseCase extends FirebaseBaseUseCase<List<SuggestedUserModel>, FirebaseNoParameters>{
  final TrendingRepository trendingRepository;

  GetSuggestedUsersUseCase(this.trendingRepository);

  @override
  Future<Either<FirebaseFailure, List<SuggestedUserModel>>> call(FirebaseNoParameters parameters) async {
    return await trendingRepository.getSuggestedUsers();
  }
}