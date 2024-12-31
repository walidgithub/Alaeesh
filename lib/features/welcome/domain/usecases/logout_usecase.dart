import 'package:dartz/dartz.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';

import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/welcome_repository.dart';

class LogoutUseCase extends FirebaseBaseUseCase<void, FirebaseNoParameters> {
  final WelcomeRepository firebaseBaseRepository;

  LogoutUseCase(this.firebaseBaseRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(FirebaseNoParameters parameters) async {
    return await firebaseBaseRepository.logout();
  }
}