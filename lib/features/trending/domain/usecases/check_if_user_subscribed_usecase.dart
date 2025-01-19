import 'package:dartz/dartz.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class CheckIfUserSubscribedUseCase extends FirebaseBaseUseCase{
  final TrendingRepository trendingRepository;

  CheckIfUserSubscribedUseCase(this.trendingRepository);

  @override
  Future<Either<FirebaseFailure, bool>> call(parameters) async {
    return await trendingRepository.checkIfUserSubscribed(parameters);
  }
}