import 'package:dartz/dartz.dart';
import 'package:last/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:last/features/layout/data/model/advice_model.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class GetUserAdvicesUseCase extends FirebaseBaseUseCase<List<AdviceModel>, FirebaseNoParameters> {
  final DashboardRepository dashboardRepository;

  GetUserAdvicesUseCase(this.dashboardRepository);

  @override
  Future<Either<FirebaseFailure, List<AdviceModel>>> call(FirebaseNoParameters  parameters) async {
    return await dashboardRepository.getUserAdvices();
  }
}