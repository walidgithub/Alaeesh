import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/domain/usecases/check_if_user_subscribed_usecase.dart';
import 'package:last/features/trending/domain/usecases/get_suggested_user_posts_usecase.dart';
import 'package:last/features/trending/presentation/bloc/trending_state.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/requests/add_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/add_comment_request.dart';
import '../../../home_page/data/model/requests/add_emoji_request.dart';
import '../../../home_page/data/model/requests/add_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_comment_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_emoji_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../home_page/data/model/requests/send_notification_request.dart';
import '../../../home_page/data/model/requests/update_comment_request.dart';
import '../../../home_page/data/model/requests/update_post_request.dart';
import '../../../home_page/domain/usecases/add_comment_emoji_usecase.dart';
import '../../../home_page/domain/usecases/add_comment_usecase.dart';
import '../../../home_page/domain/usecases/add_emoji_usecase.dart';
import '../../../home_page/domain/usecases/add_post_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/add_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import '../../../home_page/domain/usecases/delete_comment_usecase.dart';
import '../../../home_page/domain/usecases/delete_emoji_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_usecase.dart';
import '../../../home_page/domain/usecases/delete_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/send_general_notification_usecase.dart';
import '../../../home_page/domain/usecases/update_comment_usecase.dart';
import '../../../home_page/domain/usecases/update_post_usecase.dart';
import '../../data/model/requests/check_if_user_subscribed_request.dart';
import '../../data/model/requests/get_top_posts_request.dart';
import '../../domain/usecases/get_suggested_users_usecase.dart';
import '../../domain/usecases/get_top_posts_usecase.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit(
      this.getTopPostsUseCase, this.getSuggestedUsersUseCase, this.sendGeneralNotificationUseCase, this.getSuggestedUserPostsUseCase, this.addSubscriberUseCase, this.deleteSubscriberUseCase, this.deleteEmojiUseCase, this.updatePostUseCase, this.updateCommentUseCase, this.deleteCommentEmojiUseCase, this.deletePostUseCase, this.addCommentEmojiUseCase, this.addCommentUseCase, this.deleteCommentUseCase, this.addEmojiUseCase, this.addPostSubscriberUseCase, this.deletePostSubscriberUseCase, this.checkIfUserSubscribedUseCase)
      : super(TrendingInitial());

  final GetTopPostsUseCase getTopPostsUseCase;
  final GetSuggestedUsersUseCase getSuggestedUsersUseCase;
  final GetSuggestedUserPostsUseCase getSuggestedUserPostsUseCase;
  final AddSubscriberUseCase addSubscriberUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;

  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  final AddCommentUseCase addCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  final AddPostSubscriberUseCase addPostSubscriberUseCase;
  final DeletePostSubscriberUseCase deletePostSubscriberUseCase;

  final AddEmojiUseCase addEmojiUseCase;
  final DeleteEmojiUseCase deleteEmojiUseCase;

  final AddCommentEmojiUseCase addCommentEmojiUseCase;
  final DeleteCommentEmojiUseCase deleteCommentEmojiUseCase;

  final CheckIfUserSubscribedUseCase checkIfUserSubscribedUseCase;
  final SendGeneralNotificationUseCase sendGeneralNotificationUseCase;

  static TrendingCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> getTopPosts(GetTopPostsRequest getTopPostsRequest) async {
    emit(GetTopPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getTopPostsUseCase.call(getTopPostsRequest);
      result.fold(
            (failure) => emit(GetTopPostsErrorState(failure.message)),
            (posts) => emit(GetTopPostsSuccessState(posts)),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> getSuggestedUsers() async {
    emit(GetSuggestedUsersLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getSuggestedUsersUseCase.call(const FirebaseNoParameters());
      result.fold(
            (failure) => emit(GetSuggestedUsersErrorState(failure.message)),
            (suggestedUsers) => emit(GetSuggestedUsersSuccessState(suggestedUsers)),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    emit(GetSuggestedUserPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getSuggestedUserPostsUseCase.call(getSuggestedUserPostsRequest);
      result.fold(
            (failure) => emit(GetSuggestedUserPostsErrorState(failure.message)),
            (suggestedUserPosts) => emit(GetSuggestedUserPostsSuccessState(suggestedUserPosts)),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest) async {
    emit(AddSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addSubscriberUseCase.call(addSubscriberRequest);
      result.fold(
            (failure) => emit(AddSubscriberErrorState(failure.message)),
            (subscriberAdded) => emit(AddSubscriberSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest) async {
    emit(DeleteSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deleteSubscriberUseCase.call(deleteSubscriberRequest);
      result.fold(
            (failure) => emit(DeleteSubscriberErrorState(failure.message)),
            (subscriberDeleted) => emit(DeleteSubscriberSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
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
      emit(TrendingNoInternetState());
    }
  }

  Future<void> updatePost(UpdatePostRequest updatePostRequest) async {
    emit(UpdatePostLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await updatePostUseCase.call(updatePostRequest);
      result.fold(
            (failure) => emit(UpdatePostErrorState(failure.message)),
            (postUpdated) => emit(UpdatePostSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> addComment(AddCommentRequest addCommentRequest) async {
    emit(AddCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addCommentUseCase.call(addCommentRequest);
      result.fold(
            (failure) => emit(AddCommentErrorState(failure.message)),
            (commentAdded) => emit(AddCommentSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> updateComment(UpdateCommentRequest updateCommentRequest) async {
    emit(UpdateCommentLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await updateCommentUseCase.call(updateCommentRequest);
      result.fold(
            (failure) => emit(UpdateCommentErrorState(failure.message)),
            (commentAdded) => emit(UpdateCommentSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
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
      emit(TrendingNoInternetState());
    }
  }

  Future<void> addPostSubscriber(AddPostSubscriberRequest addPostSubscriberRequest) async {
    emit(AddPostSubscriberLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addPostSubscriberUseCase.call(addPostSubscriberRequest);
      result.fold(
            (failure) => emit(AddPostSubscriberErrorState(failure.message)),
            (postSubscriberAdded) => emit(AddPostSubscriberSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
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
      emit(TrendingNoInternetState());
    }
  }

  Future<void> addEmoji(AddEmojiRequest addEmojiRequest) async {
    emit(AddEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addEmojiUseCase.call(addEmojiRequest);
      result.fold(
            (failure) => emit(AddEmojiErrorState(failure.message)),
            (emojiAdded) => emit(AddEmojiSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
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
      emit(TrendingNoInternetState());
    }
  }

  Future<void> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest) async {
    emit(AddCommentEmojiLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addCommentEmojiUseCase.call(addCommentEmojiRequest);
      result.fold(
            (failure) => emit(AddCommentEmojiErrorState(failure.message)),
            (commentEmojiAdded) => emit(AddCommentEmojiSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
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
      emit(TrendingNoInternetState());
    }
  }

  Future<void> checkIfUserSubscribed(CheckIfUserSubscribedRequest checkIfUserSubscribedRequest) async {
    emit(CheckIfUserSubscribedLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await checkIfUserSubscribedUseCase.call(checkIfUserSubscribedRequest);
      result.fold(
            (failure) => emit(CheckIfUserSubscribedErrorState(failure.message)),
            (checkIfUserSubscribed) => emit(CheckIfUserSubscribedSuccessState(checkIfUserSubscribed)),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }

  Future<void> sendGeneralNotification(SendNotificationRequest sendNotificationRequest) async {
    emit(SendGeneralNotificationLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendGeneralNotificationUseCase.call(sendNotificationRequest);
      result.fold(
            (failure) => emit(SendGeneralNotificationErrorState(failure.message)),
            (notificationSent) => emit(SendGeneralNotificationSuccessState()),
      );
    } else {
      emit(TrendingNoInternetState());
    }
  }
}