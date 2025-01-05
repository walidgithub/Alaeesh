import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/home_page_model.dart';

class GetAllPostsUseCase extends FirebaseBaseUseCase{
  final HomePageRepository homePageRepository;

  GetAllPostsUseCase(this.homePageRepository);

  @override
  Future<Either<FirebaseFailure, List<HomePageModel>>> call(parameters) async {
    return await homePageRepository.getAllPosts(parameters);
  }
}