import 'package:dartz/dartz.dart';
import 'package:last/features/messages/data/model/messages_model.dart';
import 'package:last/features/messages/domain/repository/messgaes_repository.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/firebase/error/firebase_failure.dart';

class UpdateMessageToSeenUseCase extends FirebaseBaseUseCase {
  final MessagesRepository messagesRepository;

  UpdateMessageToSeenUseCase(this.messagesRepository);

  @override
  Future<Either<FirebaseFailure, void>> call(parameters) async {
    return await messagesRepository.updateMessageToSeen(parameters);
  }
}