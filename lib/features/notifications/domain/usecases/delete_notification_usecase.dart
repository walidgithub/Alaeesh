import 'package:dartz/dartz.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/notifications_repository.dart';

class DeleteNotificationUseCase extends FirebaseBaseUseCase {
  final NotificationsRepository notificationsRepository;

  DeleteNotificationUseCase(this.notificationsRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await notificationsRepository.deleteNotification(parameters);
  }
}