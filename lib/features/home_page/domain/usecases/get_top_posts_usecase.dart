import 'package:dartz/dartz.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/domain/repository/home_page_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class GetTopPostsUseCase extends FirebaseBaseUseCase<List<PostModel>, FirebaseNoParameters>{
  final HomePageRepository firebaseBaseRepository;

  GetTopPostsUseCase(this.firebaseBaseRepository);

  @override
  Future<Either<FirebaseFailure, List<PostModel>>> call(FirebaseNoParameters parameters) async {
    return await firebaseBaseRepository.getTopPosts();
  }
}