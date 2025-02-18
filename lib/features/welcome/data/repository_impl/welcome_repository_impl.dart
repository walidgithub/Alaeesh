import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import 'package:last/features/dashboard/data/model/user_model.dart';
import 'package:last/features/welcome/data/model/user_permissions_model.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../data_source/welcome_datasource.dart';
import '../model/user_model.dart';

class WelcomeRepositoryImpl extends WelcomeRepository {
  final WelcomeDataSource _welcomeDataSource;

  WelcomeRepositoryImpl(this._welcomeDataSource);

  @override
  Future<Either<FirebaseFailure, UserModel>> login() async {
    try {
      final result = await _welcomeDataSource.login();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> logout() async {
    try {
      final result = await _welcomeDataSource.logout();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> addUserPermission(UserPermissionsModel userPermissionsModel) async {
    try {
      final result = await _welcomeDataSource.addUserPermission(userPermissionsModel);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, UserPermissionsModel>> getUserPermission(String username) async {
    try {
      final result = await _welcomeDataSource.getUserPermission(username);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateUserPermission(UserPermissionsModel userPermissionsModel) async {
    try {
      final result = await _welcomeDataSource.updateUserPermission(userPermissionsModel);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateUserPermissions(UserPermissionsModel userPermissionsModel) async {
    try {
      final result = await _welcomeDataSource.updateUserPermission(userPermissionsModel);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<AllowedUserModel>>> getAllowedUser() async {
    try {
      final result = await _welcomeDataSource.getAllowedUser();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleAuthError(e)));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleFirebaseError(e)));
    } catch (e) {
      return Left(FirebaseFailure(FirebaseErrorHandler.handleGenericError(e)));
    }
  }
}
