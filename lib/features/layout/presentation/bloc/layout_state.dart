import '../../../welcome/data/model/user_permissions_model.dart';
import '../../data/model/add_post_response.dart';

abstract class LayoutState{}

class LayoutInitial extends LayoutState{}

class AddPostLoadingState extends LayoutState{}
class AddPostSuccessState extends LayoutState{
  AddPostResponse addPostResponse;
  AddPostSuccessState(this.addPostResponse);
}
class AddPostErrorState extends LayoutState{
  final String errorMessage;

  AddPostErrorState(this.errorMessage);
}

class SendAdviceLoadingState extends LayoutState{}
class SendAdviceSuccessState extends LayoutState{}
class SendAdviceErrorState extends LayoutState{
  final String errorMessage;

  SendAdviceErrorState(this.errorMessage);
}

class SendPostNotificationLoadingState extends LayoutState{}
class SendPostNotificationSuccessState extends LayoutState{}
class SendPostNotificationErrorState extends LayoutState{
  final String errorMessage;

  SendPostNotificationErrorState(this.errorMessage);
}

class LayoutNoInternetState extends LayoutState{}