import 'package:last/features/trending/data/model/suggested_user_model.dart';

import '../../../home_page/data/model/home_page_model.dart';

abstract class MyActivitiesState{}

class MyActivitiesInitial extends MyActivitiesState{}


class GetMyActivitiesLoadingState extends MyActivitiesState{}
class GetMyActivitiesSuccessState extends MyActivitiesState{
  final List<HomePageModel> homePageModel;

  GetMyActivitiesSuccessState(this.homePageModel);
}
class GetMyActivitiesErrorState extends MyActivitiesState{
  final String errorMessage;

  GetMyActivitiesErrorState(this.errorMessage);
}

class DeletePostLoadingState extends MyActivitiesState{}
class DeletePostSuccessState extends MyActivitiesState{}
class DeletePostErrorState extends MyActivitiesState{
  final String errorMessage;

  DeletePostErrorState(this.errorMessage);
}

class DeleteCommentLoadingState extends MyActivitiesState{}
class DeleteCommentSuccessState extends MyActivitiesState{}
class DeleteCommentErrorState extends MyActivitiesState{
  final String errorMessage;

  DeleteCommentErrorState(this.errorMessage);
}

class DeletePostSubscriberLoadingState extends MyActivitiesState{}
class DeletePostSubscriberSuccessState extends MyActivitiesState{}
class DeletePostSubscriberErrorState extends MyActivitiesState{
  final String errorMessage;

  DeletePostSubscriberErrorState(this.errorMessage);
}

class DeleteEmojiLoadingState extends MyActivitiesState{}
class DeleteEmojiSuccessState extends MyActivitiesState{}
class DeleteEmojiErrorState extends MyActivitiesState{
  final String errorMessage;

  DeleteEmojiErrorState(this.errorMessage);
}

class DeleteCommentEmojiLoadingState extends MyActivitiesState{}
class DeleteCommentEmojiSuccessState extends MyActivitiesState{}
class DeleteCommentEmojiErrorState extends MyActivitiesState{
  final String errorMessage;

  DeleteCommentEmojiErrorState(this.errorMessage);
}

class NoInternetState extends MyActivitiesState{}