import 'package:dartz/dartz.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/notifications_repository.dart';

class GetUnSeenNotificationsUseCase extends FirebaseBaseUseCase {
  final NotificationsRepository notificationsRepository;

  GetUnSeenNotificationsUseCase(this.notificationsRepository);

  @override
  Future<Either<FirebaseFailure, int>> call(parameters) async {
    return await notificationsRepository.getUnSeenNotifications(parameters);
  }
}