import 'package:dartz/dartz.dart';
import 'package:last/features/dashboard/domain/repository/dashboard_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class UpdateUserPermissionsUseCase extends FirebaseBaseUseCase{
  final DashboardRepository dashboardRepository;

  UpdateUserPermissionsUseCase(this.dashboardRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await dashboardRepository.updateUserPermissions(parameters);
  }
}