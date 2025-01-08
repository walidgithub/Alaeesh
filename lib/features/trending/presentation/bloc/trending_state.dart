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

class GetPostDataLoadingState extends TrendingState{}
class GetPostDataSuccessState extends TrendingState{
  final HomePageModel homePageModel;

  GetPostDataSuccessState(this.homePageModel);
}
class GetPostDataErrorState extends TrendingState{
  final String errorMessage;

  GetPostDataErrorState(this.errorMessage);
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

class NoInternetState extends TrendingState{}