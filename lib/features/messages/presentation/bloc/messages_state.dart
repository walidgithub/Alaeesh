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

class NoInternetState extends MessagesState{}