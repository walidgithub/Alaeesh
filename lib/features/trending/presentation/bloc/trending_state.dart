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

class NoInternetState extends TrendingState{}