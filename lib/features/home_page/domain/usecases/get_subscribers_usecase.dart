import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/subscribers_model.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class GetSubscribersUseCase extends FirebaseBaseUseCase{
  final HomePageRepository homePageRepository;

  GetSubscribersUseCase(this.homePageRepository);

  @override
  Future<Either<FirebaseFailure, List<SubscribersModel>>> call(parameters) async {
    return await homePageRepository.getSubscribers(parameters);
  }
}