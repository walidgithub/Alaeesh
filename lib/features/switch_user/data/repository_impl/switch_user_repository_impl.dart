import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../welcome/data/model/user_model.dart';
import '../../domain/repository/switch_user_repository.dart';
import '../data_source/switch_user_datasource.dart';

class SwitchUserRepositoryImpl extends SwitchUserRepository {
  final SwitchUserDataSource switchUserDataSource;

  SwitchUserRepositoryImpl(this.switchUserDataSource);

  @override
  Future<Either<FirebaseFailure, UserModel>> switchUser() async {
    try {
      final result = await switchUserDataSource.switchUser();
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
