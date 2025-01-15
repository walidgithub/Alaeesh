import 'package:dartz/dartz.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/notifications_model.dart';
import '../repository/notifications_repository.dart';

class GetAllNotificationsUseCase extends FirebaseBaseUseCase {
  final NotificationsRepository notificationsRepository;

  GetAllNotificationsUseCase(this.notificationsRepository);

  @override
  Future<Either<FirebaseFailure, List<NotificationsModel>>> call(parameters) async {
    return await notificationsRepository.getAllNotifications(parameters);
  }
}