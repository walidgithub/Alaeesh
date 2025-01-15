import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/Notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:last/features/Notifications/domain/usecases/get_notifications_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.deleteNotificationUseCase, this.getAllNotificationsUseCase) : super(NotificationsInitial());

  final DeleteNotificationUseCase deleteNotificationUseCase;
  final GetAllNotificationsUseCase getAllNotificationsUseCase;

  static NotificationsCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> deleteNotification(int notificationId) async {
    emit(DeleteNotificationLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deleteNotificationUseCase.call(notificationId);
      result.fold(
            (failure) => emit(DeleteNotificationErrorState(failure.message)),
            (notificationDeleted) => emit(DeleteNotificationSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> getAllNotifications(int userId) async {
    emit(GetAllNotificationsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getAllNotificationsUseCase.call(userId);
      result.fold(
            (failure) => emit(GetAllNotificationsErrorState(failure.message)),
            (notificationsResult) => emit(GetAllNotificationsSuccessState(notificationsResult)),
      );
    } else {
      emit(NoInternetState());
    }
  }
}