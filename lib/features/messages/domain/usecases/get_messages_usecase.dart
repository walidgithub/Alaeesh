import 'package:dartz/dartz.dart';
import 'package:last/features/messages/data/model/messages_model.dart';
import 'package:last/features/messages/domain/repository/messgaes_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class GetMessagesUseCase extends FirebaseBaseUseCase {
  final MessagesRepository messagesRepository;

  GetMessagesUseCase(this.messagesRepository);

  @override
  Future<Either<FirebaseFailure, List<MessagesModel>>> call(parameters) async {
    return await messagesRepository.getUserMessages(parameters);
  }
}