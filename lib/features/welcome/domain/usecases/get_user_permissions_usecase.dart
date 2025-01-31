import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/user_permissions_model.dart';
import '../../../layout/domain/repository/layout_repository.dart';

class GetUserPermissionsUseCase extends FirebaseBaseUseCase{
  final WelcomeRepository welcomeRepository;

  GetUserPermissionsUseCase(this.welcomeRepository);

  @override
  Future<Either<FirebaseFailure, UserPermissionsModel>> call(parameters) async {
    return await welcomeRepository.getUserPermission(parameters);
  }
}