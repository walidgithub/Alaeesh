import 'package:dartz/dartz.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/notifications_model.dart';
import '../repository/notifications_repository.dart';

class GetNotificationsUseCase extends FirebaseBaseUseCase {
  final NotificationsRepository notificationsRepository;

  GetNotificationsUseCase(this.notificationsRepository);

  @override
  Future<Either<FirebaseFailure, List<AlaeeshNotificationsModel>>> call(parameters) async {
    return await notificationsRepository.getUserNotifications(parameters);
  }
}