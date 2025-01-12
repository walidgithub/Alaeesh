import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/layout/domain/usecases/add_post_usecase.dart';
import 'package:last/features/layout/domain/usecases/delete_notification_usecase.dart';
import 'package:last/features/layout/domain/usecases/get_notifications_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../data/model/add_post_response.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(this.addPostUseCase, this.deleteNotificationUseCase, this.getAllNotificationsUseCase) : super(LayoutInitial());

  final AddPostUseCase addPostUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final GetAllNotificationsUseCase getAllNotificationsUseCase;

  static LayoutCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> addPost(PostModel postModel) async {
    emit(AddPostLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await addPostUseCase.call(postModel);
      signInResult.fold(
            (failure) => emit(AddPostErrorState(failure.message)),
            (postAdded) => emit(AddPostSuccessState(postAdded)),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    emit(DeleteNotificationLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deleteNotificationUseCase.call(notificationId);
      signInResult.fold(
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
      final signInResult = await getAllNotificationsUseCase.call(userId);
      signInResult.fold(
            (failure) => emit(GetAllNotificationsErrorState(failure.message)),
            (notifications) => emit(GetAllNotificationsSuccessState(notifications)),
      );
    } else {
      emit(NoInternetState());
    }
  }
}