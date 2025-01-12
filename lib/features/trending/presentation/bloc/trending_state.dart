import 'package:last/features/trending/data/model/suggested_user_model.dart';

import '../../../home_page/data/model/home_page_model.dart';

abstract class TrendingState{}

class TrendingInitial extends TrendingState{}

class GetTopPostsLoadingState extends TrendingState{}
class GetTopPostsSuccessState extends TrendingState{
  final List<HomePageModel> homePageModel;

  GetTopPostsSuccessState(this.homePageModel);
}
class GetTopPostsErrorState extends TrendingState{
  final String errorMessage;

  GetTopPostsErrorState(this.errorMessage);
}

class GetSuggestedUsersLoadingState extends TrendingState{}
class GetSuggestedUsersSuccessState extends TrendingState{
  final List<SuggestedUserModel> suggestedUserModel;

  GetSuggestedUsersSuccessState(this.suggestedUserModel);
}
class GetSuggestedUsersErrorState extends TrendingState{
  final String errorMessage;

  GetSuggestedUsersErrorState(this.errorMessage);
}

class GetSuggestedUserPostsLoadingState extends TrendingState{}
class GetSuggestedUserPostsSuccessState extends TrendingState{
  final List<HomePageModel> homePageModel;

  GetSuggestedUserPostsSuccessState(this.homePageModel);
}
class GetSuggestedUserPostsErrorState extends TrendingState{
  final String errorMessage;

  GetSuggestedUserPostsErrorState(this.errorMessage);
}

class AddSubscriberLoadingState extends TrendingState{}
class AddSubscriberSuccessState extends TrendingState{}
class AddSubscriberErrorState extends TrendingState{
  final String errorMessage;

  AddSubscriberErrorState(this.errorMessage);
}

class DeleteSubscriberLoadingState extends TrendingState{}
class DeleteSubscriberSuccessState extends TrendingState{}
class DeleteSubscriberErrorState extends TrendingState{
  final String errorMessage;

  DeleteSubscriberErrorState(this.errorMessage);
}

class UpdatePostLoadingState extends TrendingState{}
class UpdatePostSuccessState extends TrendingState{}
class UpdatePostErrorState extends TrendingState{
  final String errorMessage;

  UpdatePostErrorState(this.errorMessage);
}

class DeletePostLoadingState extends TrendingState{}
class DeletePostSuccessState extends TrendingState{}
class DeletePostErrorState extends TrendingState{
  final String errorMessage;

  DeletePostErrorState(this.errorMessage);
}

class AddCommentLoadingState extends TrendingState{}
class AddCommentSuccessState extends TrendingState{}
class AddCommentErrorState extends TrendingState{
  final String errorMessage;

  AddCommentErrorState(this.errorMessage);
}

class DeleteCommentLoadingState extends TrendingState{}
class DeleteCommentSuccessState extends TrendingState{}
class DeleteCommentErrorState extends TrendingState{
  final String errorMessage;

  DeleteCommentErrorState(this.errorMessage);
}

class UpdateCommentLoadingState extends TrendingState{}
class UpdateCommentSuccessState extends TrendingState{}
class UpdateCommentErrorState extends TrendingState{
  final String errorMessage;

  UpdateCommentErrorState(this.errorMessage);
}

class AddPostSubscriberLoadingState extends TrendingState{}
class AddPostSubscriberSuccessState extends TrendingState{}
class AddPostSubscriberErrorState extends TrendingState{
  final String errorMessage;

  AddPostSubscriberErrorState(this.errorMessage);
}

class DeletePostSubscriberLoadingState extends TrendingState{}
class DeletePostSubscriberSuccessState extends TrendingState{}
class DeletePostSubscriberErrorState extends TrendingState{
  final String errorMessage;

  DeletePostSubscriberErrorState(this.errorMessage);
}

class AddEmojiLoadingState extends TrendingState{}
class AddEmojiSuccessState extends TrendingState{}
class AddEmojiErrorState extends TrendingState{
  final String errorMessage;

  AddEmojiErrorState(this.errorMessage);
}

class DeleteEmojiLoadingState extends TrendingState{}
class DeleteEmojiSuccessState extends TrendingState{}
class DeleteEmojiErrorState extends TrendingState{
  final String errorMessage;

  DeleteEmojiErrorState(this.errorMessage);
}

class DeleteCommentEmojiLoadingState extends TrendingState{}
class DeleteCommentEmojiSuccessState extends TrendingState{}
class DeleteCommentEmojiErrorState extends TrendingState{
  final String errorMessage;

  DeleteCommentEmojiErrorState(this.errorMessage);
}

class AddCommentEmojiLoadingState extends TrendingState{}
class AddCommentEmojiSuccessState extends TrendingState{}
class AddCommentEmojiErrorState extends TrendingState{
  final String errorMessage;

  AddCommentEmojiErrorState(this.errorMessage);
}

class CheckIfUserSubscribedLoadingState extends TrendingState{}
class CheckIfUserSubscribedSuccessState extends TrendingState{
  final bool checkIfUserSubscribed;

  CheckIfUserSubscribedSuccessState(this.checkIfUserSubscribed);
}
class CheckIfUserSubscribedErrorState extends TrendingState{
  final String errorMessage;

  CheckIfUserSubscribedErrorState(this.errorMessage);
}

class NoInternetState extends TrendingState{}