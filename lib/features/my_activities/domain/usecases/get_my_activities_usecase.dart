import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../repository/my_activities_repository.dart';

class GetMyActivitiesUseCase extends FirebaseBaseUseCase{
  final MyActivitiesRepository myActivitiesRepository;

  GetMyActivitiesUseCase(this.myActivitiesRepository);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> call(parameters) async {
    return await myActivitiesRepository.getMyActivities(parameters);
  }
}