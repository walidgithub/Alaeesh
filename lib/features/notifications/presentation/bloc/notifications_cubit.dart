import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/notifications/data/model/requests/get_post_data_request.dart';
import 'package:last/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_post_data_usecase.dart';
import 'package:last/features/notifications/domain/usecases/get_unseen_notifications_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../data/model/requests/get_notifications_request.dart';
import '../../data/model/requests/update_notification_to_seeen_request.dart';
import '../../domain/usecases/update_notification_to_seen_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.getNotificationsUseCase, this.updateNotificationToSeenUseCase, this.getUnSeenNotificationsUseCase)
      : super(NotificationsInitial());

  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnSeenNotificationsUseCase getUnSeenNotificationsUseCase;
  final UpdateNotificationToSeenUseCase updateNotificationToSeenUseCase;


  static NotificationsCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> getUserNotifications(GetNotificationsRequest getNotificationsRequest) async {
    emit(GetNotificationsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getNotificationsUseCase.call(getNotificationsRequest);
      result.fold(
            (failure) => emit(GetNotificationsErrorState(failure.message)),
            (notifications) => emit(GetNotificationsSuccessState(notifications)),
      );
    } else {
      emit(NotificationsNoInternetState());
    }
  }

  Future<void> updateNotificationToSeen(UpdateNotificationToSeenRequest updateNotificationToSeenRequest) async {
    emit(UpdateNotificationToSeenLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await updateNotificationToSeenUseCase.call(updateNotificationToSeenRequest);
      result.fold(
            (failure) => emit(UpdateNotificationToSeenErrorState(failure.message)),
            (messageUpdated) => emit(UpdateNotificationToSeenSuccessState()),
      );
    } else {
      emit(NotificationsNoInternetState());
    }
  }

  Future<void> getUnSeenNotifications(GetNotificationsRequest getNotificationsRequest) async {
    emit(GetUnSeenNotificationsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getUnSeenNotificationsUseCase.call(getNotificationsRequest);
      result.fold(
            (failure) => emit(GetUnSeenNotificationsErrorState(failure.message)),
            (unSeenNotifications) => emit(GetUnSeenNotificationsSuccessState(unSeenNotifications)),
      );
    } else {
      emit(NotificationsNoInternetState());
    }
  }
}