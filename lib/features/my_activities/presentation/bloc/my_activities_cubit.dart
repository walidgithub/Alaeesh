import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/my_activities/data/model/requests/get_my_activities_request.dart';
import 'package:last/features/my_activities/domain/usecases/get_my_activities_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/requests/delete_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import '../../../home_page/domain/usecases/delete_comment_usecase.dart';
import '../../../home_page/domain/usecases/delete_emoji_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_usecase.dart';
import '../../../home_page/domain/usecases/delete_subscriber_usecase.dart';
import 'my_activities_state.dart';

class MyActivitiesCubit extends Cubit<MyActivitiesState> {
  MyActivitiesCubit(
      this.getMyActivitiesUseCase, this.deleteSubscriberUseCase, this.deleteEmojiUseCase, this.deleteCommentEmojiUseCase, this.deletePostUseCase, this.deleteCommentUseCase, this.deletePostSubscriberUseCase)
      : super(MyActivitiesInitial());

  final GetMyActivitiesUseCase getMyActivitiesUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;

  final DeletePostUseCase deletePostUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final DeletePostSubscriberUseCase deletePostSubscriberUseCase;
  final DeleteEmojiUseCase deleteEmojiUseCase;
  final DeleteCommentEmojiUseCase deleteCommentEmojiUseCase;

  static MyActivitiesCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> getMyActivities(GetMyActivitiesRequest getMyActivitiesRequest) async {
    emit(GetMyActivitiesLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getMyActivitiesUseCase.call(getMyActivitiesRequest);
      signInResult.fold(
            (failure) => emit(GetMyActivitiesErrorState(failure.message)),
            (myActivities) => emit(GetMyActivitiesSuccessState(myActivities)),
      );
    } else {
      emit(NoInternetState());
    }
  }
  
  Future<void> deletePost(String postId) async {
    emit(DeletePostLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deletePostUseCase.call(postId);
      signInResult.fold(
            (failure) => emit(DeletePostErrorState(failure.message)),
            (postDeleted) => emit(DeletePostSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest) async {
    emit(DeleteCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deleteCommentUseCase.call(deleteCommentRequest);
      signInResult.fold(
            (failure) => emit(DeleteCommentErrorState(failure.message)),
            (commentDeleted) => emit(DeleteCommentSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest) async {
    emit(DeletePostSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deletePostSubscriberUseCase.call(deletePostSubscriberRequest);
      signInResult.fold(
            (failure) => emit(DeletePostSubscriberErrorState(failure.message)),
            (postSubscriberDeleted) => emit(DeletePostSubscriberSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest) async {
    emit(DeleteEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deleteEmojiUseCase.call(deleteEmojiRequest);
      signInResult.fold(
            (failure) => emit(DeleteEmojiErrorState(failure.message)),
            (emojiDeleted) => emit(DeleteEmojiSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest) async {
    emit(DeleteEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deleteCommentEmojiUseCase.call(deleteCommentEmojiRequest);
      signInResult.fold(
            (failure) => emit(DeleteCommentEmojiErrorState(failure.message)),
            (commentEmojiDeleted) => emit(DeleteCommentEmojiSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }
}