import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/core/firebase/error/firebase_failure.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/welcome/data/model/user_permissions_model.dart';
import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../domain/repository/layout_repository.dart';
import '../data_source/layout_datasource.dart';
import '../model/add_post_response.dart';
import '../model/requests/send_advise_request.dart';

class LayoutRepositoryImpl extends LayoutRepository {
  final LayoutDataSource _layoutDataSource;
  LayoutRepositoryImpl(this._layoutDataSource);

  @override
  Future<Either<FirebaseFailure, AddPostResponse>> addPost(PostModel postModel) async {
    try {
      final result = await _layoutDataSource.addPost(postModel);
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
  Future<Either<FirebaseFailure, void>> sendAdvice(SendAdviceRequest sendAdviceRequest) async {
    try {
      final result = await _layoutDataSource.sendAdvice(sendAdviceRequest);
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
      final result = await _layoutDataSource.getUserPermission(username);
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