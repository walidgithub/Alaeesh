import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/data/model/user_model.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/welcome_repository.dart';

class LoginUseCase extends FirebaseBaseUseCase<UserModel, FirebaseNoParameters> {
  final WelcomeRepository firebaseBaseRepository;

  LoginUseCase(this.firebaseBaseRepository);

  @override
  Future<Either<FirebaseFailure, UserModel>> call(FirebaseNoParameters parameters) async {
    return await firebaseBaseRepository.login();
  }
}