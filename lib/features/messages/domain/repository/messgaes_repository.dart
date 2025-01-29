import 'package:dartz/dartz.dart';

import '../../../../core/firebase/error/firebase_failure.dart';
import '../../data/model/messages_model.dart';
import '../../data/model/requests/get_messages_request.dart';
import '../../data/model/requests/update_message_to_seeen_request.dart';

abstract class MessagesRepository {
  Future<Either<FirebaseFailure, List<MessagesModel>>> getUserMessages(
      GetMessagesRequest getMessagesRequest);

  Future<Either<FirebaseFailure, void>> updateMessageToSeen(UpdateMessageToSeenRequest updateMessageToSeenRequest);

  Future<Either<FirebaseFailure, int>> getUnSeenMessages(GetMessagesRequest getMessagesRequest);
}