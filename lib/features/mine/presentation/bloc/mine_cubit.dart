import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../data/model/requests/get_mine_request.dart';
import '../../domain/usecases/get_mine_usecase.dart';
import 'mine_state.dart';

class MineCubit extends Cubit<MineState> {
  MineCubit(
      this.getMineUseCase, this.deleteSubscriberUseCase, this.deleteEmojiUseCase, this.deleteCommentEmojiUseCase, this.deletePostUseCase, this.deleteCommentUseCase, this.deletePostSubscriberUseCase)
      : super(MineInitial());

  final GetMineUseCase getMineUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;

  final DeletePostUseCase deletePostUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final DeletePostSubscriberUseCase deletePostSubscriberUseCase;
  final DeleteEmojiUseCase deleteEmojiUseCase;
  final DeleteCommentEmojiUseCase deleteCommentEmojiUseCase;

  static MineCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> getMine(GetMineRequest getMineRequest) async {
    emit(GetMineLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getMineUseCase.call(getMineRequest);
      result.fold(
            (failure) => emit(GetMineErrorState(failure.message)),
            (mine) => emit(GetMineSuccessState(mine)),
      );
    } else {
      emit(MineNoInternetState());
    }
  }
  
  Future<void> deletePost(String postId) async {
    emit(DeletePostLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deletePostUseCase.call(postId);
      result.fold(
            (failure) => emit(DeletePostErrorState(failure.message)),
            (postDeleted) => emit(DeletePostSuccessState()),
      );
    } else {
      emit(MineNoInternetState());
    }
  }

  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest) async {
    emit(DeleteCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deleteCommentUseCase.call(deleteCommentRequest);
      result.fold(
            (failure) => emit(DeleteCommentErrorState(failure.message)),
            (commentDeleted) => emit(DeleteCommentSuccessState()),
      );
    } else {
      emit(MineNoInternetState());
    }
  }

  Future<void> deletePostSubscriber(DeletePostSubscriberRequest deletePostSubscriberRequest) async {
    emit(DeletePostSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deletePostSubscriberUseCase.call(deletePostSubscriberRequest);
      result.fold(
            (failure) => emit(DeletePostSubscriberErrorState(failure.message)),
            (postSubscriberDeleted) => emit(DeletePostSubscriberSuccessState()),
      );
    } else {
      emit(MineNoInternetState());
    }
  }

  Future<void> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest) async {
    emit(DeleteEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deleteEmojiUseCase.call(deleteEmojiRequest);
      result.fold(
            (failure) => emit(DeleteEmojiErrorState(failure.message)),
            (emojiDeleted) => emit(DeleteEmojiSuccessState()),
      );
    } else {
      emit(MineNoInternetState());
    }
  }

  Future<void> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest) async {
    emit(DeleteEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deleteCommentEmojiUseCase.call(deleteCommentEmojiRequest);
      result.fold(
            (failure) => emit(DeleteCommentEmojiErrorState(failure.message)),
            (commentEmojiDeleted) => emit(DeleteCommentEmojiSuccessState()),
      );
    } else {
      emit(MineNoInternetState());
    }
  }
}