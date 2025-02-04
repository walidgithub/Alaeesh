import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class UpdateUserPermissionsUseCase extends FirebaseBaseUseCase {
  final WelcomeRepository welcomeRepository;

  UpdateUserPermissionsUseCase(this.welcomeRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await welcomeRepository.updateUserPermissions(parameters);
  }
}