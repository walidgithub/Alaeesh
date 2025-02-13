import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/home_page_model.dart';
import '../../../notifications/data/model/notifications_model.dart';
import '../../../notifications/domain/repository/notifications_repository.dart';

class GetPostDataUseCase extends FirebaseBaseUseCase {
  final HomePageRepository homePageRepository;

  GetPostDataUseCase(this.homePageRepository);

  @override
  Future<Either<FirebaseFailure, HomePageModel>> call(parameters) async {
    return await homePageRepository.getPostData(parameters);
  }
}