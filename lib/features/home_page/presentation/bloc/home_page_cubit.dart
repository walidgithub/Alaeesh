import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/home_page/data/model/requests/add_comment_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/update_post_request.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_post_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../data/model/requests/add_comment_request.dart';
import '../../data/model/requests/add_emoji_request.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_comment_emoji_request.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/requests/update_comment_request.dart';
import '../../domain/usecases/add_comment_emoji_usecase.dart';
import '../../domain/usecases/delete_emoji_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_all_posts_usecase.dart';
import '../../domain/usecases/get_top_posts_usecase.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(this.deletePostUseCase, this.addCommentUseCase, this.deleteCommentUseCase, this.addEmojiUseCase, this.addCommentEmojiUseCase, this.getAllPostsUseCase,
      this.getTopPostsUseCase,this.deleteCommentEmojiUseCase,this.updateCommentUseCase,this.updatePostUseCase,this.deleteEmojiUseCase, this.deleteSubscriberUseCase, this.addSubscriberUseCase) : super(HomePageInitial());

  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  final AddCommentUseCase addCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  final AddSubscriberUseCase addSubscriberUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;

  final AddEmojiUseCase addEmojiUseCase;
  final DeleteEmojiUseCase deleteEmojiUseCase;

  final AddCommentEmojiUseCase addCommentEmojiUseCase;
  final DeleteCommentEmojiUseCase deleteCommentEmojiUseCase;

  final GetAllPostsUseCase getAllPostsUseCase;
  final GetTopPostsUseCase getTopPostsUseCase;

  static HomePageCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> getAllPosts() async {
    emit(GetAllPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getAllPostsUseCase.call(const FirebaseNoParameters());
      signInResult.fold(
            (failure) => emit(GetAllPostsErrorState(failure.message)),
            (posts) => emit(GetAllPostsSuccessState(posts)),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> getTopPosts() async {
    emit(GetTopPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getTopPostsUseCase.call(const FirebaseNoParameters());
      signInResult.fold(
            (failure) => emit(GetTopPostsErrorState(failure.message)),
            (posts) => emit(GetTopPostsSuccessState(posts)),
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

  Future<void> updatePost(UpdatePostRequest updatePostRequest) async {
    emit(UpdatePostLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await updatePostUseCase.call(updatePostRequest);
      signInResult.fold(
            (failure) => emit(UpdatePostErrorState(failure.message)),
            (postDeleted) => emit(UpdatePostSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> addComment(AddCommentRequest addCommentRequest) async {
    emit(AddCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await addCommentUseCase.call(addCommentRequest);
      signInResult.fold(
            (failure) => emit(AddCommentErrorState(failure.message)),
            (commentAdded) => emit(AddCommentSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> updateComment(UpdateCommentRequest updateCommentRequest) async {
    emit(UpdateCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await updateCommentUseCase.call(updateCommentRequest);
      signInResult.fold(
            (failure) => emit(UpdateCommentErrorState(failure.message)),
            (commentAdded) => emit(UpdateCommentSuccessState()),
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

  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest) async {
    emit(AddSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await addSubscriberUseCase.call(addSubscriberRequest);
      signInResult.fold(
            (failure) => emit(AddSubscriberErrorState(failure.message)),
            (emojiAdded) => emit(AddSubscriberSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest) async {
    emit(DeleteSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await deleteSubscriberUseCase.call(deleteSubscriberRequest);
      signInResult.fold(
            (failure) => emit(DeleteSubscriberErrorState(failure.message)),
            (emojiDeleted) => emit(DeleteSubscriberSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> addEmoji(AddEmojiRequest addEmojiRequest) async {
    emit(AddEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await addEmojiUseCase.call(addEmojiRequest);
      signInResult.fold(
            (failure) => emit(AddEmojiErrorState(failure.message)),
            (emojiAdded) => emit(AddEmojiSuccessState()),
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

  Future<void> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest) async {
    emit(AddCommentEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await addCommentEmojiUseCase.call(addCommentEmojiRequest);
      signInResult.fold(
            (failure) => emit(AddCommentEmojiErrorState(failure.message)),
            (commentEmojiAdded) => emit(AddCommentEmojiSuccessState()),
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