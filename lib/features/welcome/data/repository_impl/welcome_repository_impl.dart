import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import 'package:last/features/welcome/data/model/user_permissions_model.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../data_source/welcome_datasource.dart';
import '../model/user_model.dart';

class WelcomeRepositoryImpl extends WelcomeRepository {
  final WelcomeDataSource _authDataSource;

  WelcomeRepositoryImpl(this._authDataSource);

  @override
  Future<Either<FirebaseFailure, UserModel>> login() async {
    try {
      final result = await _authDataSource.login();
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
      final result = await _authDataSource.logout();
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
      final result = await _authDataSource.addUserPermission(userPermissionsModel);
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
