import 'package:last/features/messages/data/model/messages_model.dart';

abstract class MessagesState{}

class MessagesInitial extends MessagesState{}

class GetMessagesLoadingState extends MessagesState{}
class GetMessagesSuccessState extends MessagesState{
  List<MessagesModel> messagesList;
  GetMessagesSuccessState(this.messagesList);
}
class GetMessagesErrorState extends MessagesState{
  final String errorMessage;

  GetMessagesErrorState(this.errorMessage);
}

class UpdateMessageToSeenLoadingState extends MessagesState{}
class UpdateMessageToSeenSuccessState extends MessagesState{}
class UpdateMessageToSeenErrorState extends MessagesState{
  final String errorMessage;

  UpdateMessageToSeenErrorState(this.errorMessage);
}

class GetUnSeenMessagesLoadingState extends MessagesState{}
class GetUnSeenMessagesSuccessState extends MessagesState{
  int unSeenMessagesCount;
  GetUnSeenMessagesSuccessState(this.unSeenMessagesCount);
}
class GetUnSeenMessagesErrorState extends MessagesState{
  final String errorMessage;

  GetUnSeenMessagesErrorState(this.errorMessage);
}

class MessagesNoInternetState extends MessagesState{}