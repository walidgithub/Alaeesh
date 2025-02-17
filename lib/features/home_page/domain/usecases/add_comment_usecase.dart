import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class AddCommentUseCase extends FirebaseBaseUseCase{
  final HomePageRepository homePageRepository;

  AddCommentUseCase(this.homePageRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await homePageRepository.addComment(parameters);
  }
}