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

class NoInternetState extends TrendingState{}