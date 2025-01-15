import 'package:last/features/Notifications/data/model/notifications_model.dart';

abstract class NotificationsState{}

class NotificationsInitial extends NotificationsState{}

class DeleteNotificationLoadingState extends NotificationsState{}
class DeleteNotificationSuccessState extends NotificationsState{}
class DeleteNotificationErrorState extends NotificationsState{
  final String errorMessage;

  DeleteNotificationErrorState(this.errorMessage);
}

class GetAllNotificationsLoadingState extends NotificationsState{}
class GetAllNotificationsSuccessState extends NotificationsState{
  final List<NotificationsModel> notificationsResult;

  GetAllNotificationsSuccessState(this.notificationsResult);
}
class GetAllNotificationsErrorState extends NotificationsState{
  final String errorMessage;

  GetAllNotificationsErrorState(this.errorMessage);
}

class NoInternetState extends NotificationsState{}