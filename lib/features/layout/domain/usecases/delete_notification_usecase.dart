import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/layout_repository.dart';

class DeleteNotificationUseCase extends FirebaseBaseUseCase {
  final LayoutRepository firebaseBaseRepository;

  DeleteNotificationUseCase(this.firebaseBaseRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await firebaseBaseRepository.deleteNotification(parameters);
  }
}