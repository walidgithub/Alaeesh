import '../../../home_page/data/model/post_model.dart';
import '../../data/model/notifications_model.dart';

abstract class NotificationsState{}

class NotificationsInitial extends NotificationsState{}

class GetNotificationsLoadingState extends NotificationsState{}
class GetNotificationsSuccessState extends NotificationsState{
  List<AlaeeshNotificationsModel> alaeeshNotificationsList;
  GetNotificationsSuccessState(this.alaeeshNotificationsList);
}
class GetNotificationsErrorState extends NotificationsState{
  final String errorNotification;

  GetNotificationsErrorState(this.errorNotification);
}

class GetPostDataLoadingState extends NotificationsState{}
class GetPostDataSuccessState extends NotificationsState{
  PostModel postModel;
  GetPostDataSuccessState(this.postModel);
}
class GetPostDataErrorState extends NotificationsState{
  final String errorNotification;

  GetPostDataErrorState(this.errorNotification);
}

class UpdateNotificationToSeenLoadingState extends NotificationsState{}
class UpdateNotificationToSeenSuccessState extends NotificationsState{}
class UpdateNotificationToSeenErrorState extends NotificationsState{
  final String errorNotification;

  UpdateNotificationToSeenErrorState(this.errorNotification);
}

class GetUnSeenNotificationsLoadingState extends NotificationsState{}
class GetUnSeenNotificationsSuccessState extends NotificationsState{
  int unSeenNotificationsCount;
  GetUnSeenNotificationsSuccessState(this.unSeenNotificationsCount);
}
class GetUnSeenNotificationsErrorState extends NotificationsState{
  final String errorNotification;

  GetUnSeenNotificationsErrorState(this.errorNotification);
}

class NotificationsNoInternetState extends NotificationsState{}