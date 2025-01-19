import 'package:dartz/dartz.dart';

import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../repository/layout_repository.dart';

class GetUserPermissionsUseCase extends FirebaseBaseUseCase{
  final LayoutRepository layoutRepository;

  GetUserPermissionsUseCase(this.layoutRepository);

  @override
  Future<Either<FirebaseFailure, UserPermissionsModel>> call(parameters) async {
    return await layoutRepository.getUserPermission(parameters);
  }
}