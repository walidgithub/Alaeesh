import 'package:dartz/dartz.dart';
import 'package:last/features/dashboard/data/model/user_model.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/user_permissions_model.dart';
import '../../../layout/domain/repository/layout_repository.dart';

class GetAllowedUsersUseCase extends FirebaseBaseUseCase<List<AllowedUserModel>, FirebaseNoParameters>{
  final WelcomeRepository welcomeRepository;

  GetAllowedUsersUseCase(this.welcomeRepository);

  @override
  Future<Either<FirebaseFailure, List<AllowedUserModel>>> call(FirebaseNoParameters  parameters) async {
    return await welcomeRepository.getAllowedUser();
  }
}