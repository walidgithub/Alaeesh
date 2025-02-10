import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/notifications_model.dart';
import '../repository/notifications_repository.dart';

class GetPostDataUseCase extends FirebaseBaseUseCase {
  final NotificationsRepository notificationsRepository;

  GetPostDataUseCase(this.notificationsRepository);

  @override
  Future<Either<FirebaseFailure, PostModel>> call(parameters) async {
    return await notificationsRepository.getPostData(parameters);
  }
}