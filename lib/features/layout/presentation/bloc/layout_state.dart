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

class SendAdviseLoadingState extends LayoutState{}
class SendAdviseSuccessState extends LayoutState{}
class SendAdviseErrorState extends LayoutState{
  final String errorMessage;

  SendAdviseErrorState(this.errorMessage);
}

class NoInternetState extends LayoutState{}