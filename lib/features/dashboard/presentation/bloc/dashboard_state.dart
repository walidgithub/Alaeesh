import 'package:last/features/layout/data/model/advice_model.dart';

import '../../../home_page/data/model/home_page_model.dart';

abstract class DashboardState{}

class DashboardInitial extends DashboardState{}

class GetUserAdvicesLoadingState extends DashboardState{}
class GetUserAdvicesSuccessState extends DashboardState{
  List<AdviceModel> adviceList;
  GetUserAdvicesSuccessState(this.adviceList);
}
class GetUserAdvicesErrorState extends DashboardState{
  final String errorMessage;

  GetUserAdvicesErrorState(this.errorMessage);
}

class DeletePostLoadingState extends DashboardState{}
class DeletePostSuccessState extends DashboardState{}
class DeletePostErrorState extends DashboardState{
  final String errorMessage;

  DeletePostErrorState(this.errorMessage);
}

class DeleteCommentLoadingState extends DashboardState{}
class DeleteCommentSuccessState extends DashboardState{}
class DeleteCommentErrorState extends DashboardState{
  final String errorMessage;

  DeleteCommentErrorState(this.errorMessage);
}

class DeletePostSubscriberLoadingState extends DashboardState{}
class DeletePostSubscriberSuccessState extends DashboardState{}
class DeletePostSubscriberErrorState extends DashboardState{
  final String errorMessage;

  DeletePostSubscriberErrorState(this.errorMessage);
}

class GetAllPostsLoadingState extends DashboardState{}
class GetAllPostsSuccessState extends DashboardState{
  final List<HomePageModel> homePageModel;

  GetAllPostsSuccessState(this.homePageModel);
}
class GetAllPostsErrorState extends DashboardState{
  final String errorMessage;

  GetAllPostsErrorState(this.errorMessage);
}

class DashboardSendReplyLoadingState extends DashboardState{}
class DashboardSendReplySuccessState extends DashboardState{}
class DashboardSendReplyErrorState extends DashboardState{
  final String errorMessage;

  DashboardSendReplyErrorState(this.errorMessage);
}

class DashboardNoInternetState extends DashboardState{}