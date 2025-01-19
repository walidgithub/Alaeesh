import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../repository/welcome_repository.dart';

class AddUserPermissionsUseCase extends FirebaseBaseUseCase {
  final WelcomeRepository firebaseBaseRepository;

  AddUserPermissionsUseCase(this.firebaseBaseRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await firebaseBaseRepository.addUserPermission(parameters);
  }
}