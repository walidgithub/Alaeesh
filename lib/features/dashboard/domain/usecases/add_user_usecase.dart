import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/dashboard_repository.dart';

class AddUserUseCase extends FirebaseBaseUseCase{
  final DashboardRepository dashboardRepository;

  AddUserUseCase(this.dashboardRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await dashboardRepository.addUser(parameters);
  }
}