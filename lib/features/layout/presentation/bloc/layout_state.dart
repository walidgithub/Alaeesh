import 'package:last/features/layout/data/model/notifications_model.dart';

abstract class LayoutState{}

class LayoutInitial extends LayoutState{}

class AddPostLoadingState extends LayoutState{}
class AddPostSuccessState extends LayoutState{}
class AddPostErrorState extends LayoutState{
  final String errorMessage;

  AddPostErrorState(this.errorMessage);
}

class DeleteNotificationLoadingState extends LayoutState{}
class DeleteNotificationSuccessState extends LayoutState{}
class DeleteNotificationErrorState extends LayoutState{
  final String errorMessage;

  DeleteNotificationErrorState(this.errorMessage);
}

class GetAllNotificationsLoadingState extends LayoutState{}
class GetAllNotificationsSuccessState extends LayoutState{
  final List<NotificationsModel> notificationsModel;

  GetAllNotificationsSuccessState(this.notificationsModel);
}
class GetAllNotificationsErrorState extends LayoutState{
  final String errorMessage;

  GetAllNotificationsErrorState(this.errorMessage);
}

class NoInternetState extends LayoutState{}