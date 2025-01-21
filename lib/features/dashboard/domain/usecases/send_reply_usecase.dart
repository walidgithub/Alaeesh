import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/dashboard_repository.dart';

class SendReplyUseCase extends FirebaseBaseUseCase{
  final DashboardRepository dashboardRepository;

  SendReplyUseCase(this.dashboardRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await dashboardRepository.sendReply(parameters);
  }
}