import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/firebase/error/firebase_error_handler.dart';
import '../../../../core/firebase/error/firebase_failure.dart';
import '../../domain/repository/messgaes_repository.dart';
import '../data_source/messages_datasource.dart';
import '../model/messages_model.dart';
import '../model/requests/get_messages_request.dart';

class MessagesRepositoryImpl extends MessagesRepository {
  final MessagesDataSource messagesDataSource;

  MessagesRepositoryImpl(this.messagesDataSource);

  @override
  Future<Either<FirebaseFailure, List<MessagesModel>>> getUserMessages(
      GetMessagesRequest getMessagesRequest) async {
    try {
      final result =
          await messagesDataSource.getUserMessages(getMessagesRequest);
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
