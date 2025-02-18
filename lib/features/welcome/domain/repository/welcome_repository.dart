import 'package:dartz/dartz.dart';
import 'package:last/features/welcome/data/model/user_model.dart';

import '../../../../core/firebase/error/firebase_failure.dart';
import '../../../dashboard/data/model/user_model.dart';
import '../../data/model/user_permissions_model.dart';

abstract class WelcomeRepository {
  Future<Either<FirebaseFailure, void>> updateUserPermissions(UserPermissionsModel userPermissionsModel);
  Future<Either<FirebaseFailure, UserModel>> login();
  Future<Either<FirebaseFailure, void>> addUserPermission(UserPermissionsModel userPermissionsModel);
  Future<Either<FirebaseFailure, UserPermissionsModel>> getUserPermission(String username);
  Future<Either<FirebaseFailure, void>> logout();
  Future<Either<FirebaseFailure, List<AllowedUserModel>>> getAllowedUser();
}