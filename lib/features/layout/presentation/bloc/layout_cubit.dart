import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/layout/domain/usecases/add_post_usecase.dart';
import 'package:last/features/welcome/domain/usecases/get_user_permissions_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../home_page/data/model/requests/send_notification_request.dart';
import '../../../home_page/domain/usecases/send_post_notification_usecase.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../../data/model/requests/send_advise_request.dart';
import '../../domain/usecases/send_advise_usecase.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(this.addPostUseCase, this.sendAdviceUseCase, this.sendPostNotificationUseCase) : super(LayoutInitial());

  final AddPostUseCase addPostUseCase;
  final SendAdviceUseCase sendAdviceUseCase;
  final SendPostNotificationUseCase sendPostNotificationUseCase;

  static LayoutCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> addPost(PostModel postModel) async {
    emit(AddPostLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addPostUseCase.call(postModel);
      result.fold(
            (failure) => emit(AddPostErrorState(failure.message)),
            (postAdded) => emit(AddPostSuccessState(postAdded)),
      );
    } else {
      emit(LayoutNoInternetState());
    }
  }

  Future<void> sendAdvice(SendAdviceRequest sendAdviceRequest) async {
    emit(SendAdviceLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendAdviceUseCase.call(sendAdviceRequest);
      result.fold(
            (failure) => emit(SendAdviceErrorState(failure.message)),
            (adviseSent) => emit(SendAdviceSuccessState()),
      );
    } else {
      emit(LayoutNoInternetState());
    }
  }

  Future<void> sendPostNotification(SendNotificationRequest sendNotificationRequest) async {
    emit(SendPostNotificationLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendPostNotificationUseCase.call(sendNotificationRequest);
      result.fold(
            (failure) => emit(SendPostNotificationErrorState(failure.message)),
            (notificationSent) => emit(SendPostNotificationSuccessState()),
      );
    } else {
      emit(LayoutNoInternetState());
    }
  }
}