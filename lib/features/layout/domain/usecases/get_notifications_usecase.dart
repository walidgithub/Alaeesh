import 'package:dartz/dartz.dart';
import 'package:last/features/layout/data/model/notifications_model.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/layout_repository.dart';

class GetAllNotificationsUseCase extends FirebaseBaseUseCase {
  final LayoutRepository layoutRepository;

  GetAllNotificationsUseCase(this.layoutRepository);

  @override
  Future<Either<FirebaseFailure, List<NotificationsModel>>> call(parameters) async {
    return await layoutRepository.getAllNotifications(parameters);
  }
}