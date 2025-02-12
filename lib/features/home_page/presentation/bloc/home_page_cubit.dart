import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/home_page/data/model/requests/add_comment_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_emoji_request.dart';
import 'package:last/features/home_page/data/model/requests/send_notification_request.dart';
import 'package:last/features/home_page/data/model/requests/update_post_request.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_post_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_post_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_home_posts_usecase.dart';
import 'package:last/features/home_page/domain/usecases/search_post_usecase.dart';
import 'package:last/features/home_page/domain/usecases/send_post_notification_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_post_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../notifications/data/model/requests/get_post_data_request.dart';
import '../../domain/usecases/get_post_data_usecase.dart';
import '../../data/model/requests/add_comment_request.dart';
import '../../data/model/requests/add_emoji_request.dart';
import '../../data/model/requests/add_post_subscriber_request.dart';
import '../../data/model/requests/add_subscriber_request.dart';
import '../../data/model/requests/delete_comment_emoji_request.dart';
import '../../data/model/requests/delete_post_subscriber_request.dart';
import '../../data/model/requests/delete_subscriber_request.dart';
import '../../data/model/requests/get_posts_request.dart';
import '../../data/model/requests/get_subscribers_request.dart';
import '../../data/model/requests/update_comment_request.dart';
import '../../domain/usecases/add_comment_emoji_usecase.dart';
import '../../domain/usecases/add_subscriber_usecase.dart';
import '../../domain/usecases/delete_emoji_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/delete_subscriber_usecase.dart';
import '../../domain/usecases/get_all_posts_usecase.dart';
import '../../domain/usecases/get_subscribers_usecase.dart';
import '../../domain/usecases/send_general_notification_usecase.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(this.deletePostUseCase, this.getPostDataUseCase, this.getHomePostsUseCase, this.sendGeneralNotificationUseCase, this.sendPostNotificationUseCase, this.addCommentUseCase, this.searchPostUseCase, this.deleteCommentUseCase, this.addEmojiUseCase, this.addCommentEmojiUseCase, this.getAllPostsUseCase, this.deleteCommentEmojiUseCase,this.updateCommentUseCase,this.updatePostUseCase,this.addSubscriberUseCase,this.deleteSubscriberUseCase,this.getSubscribersUseCase,this.deleteEmojiUseCase, this.deletePostSubscriberUseCase, this.addPostSubscriberUseCase) : super(HomePageInitial());

  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  final AddCommentUseCase addCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  final AddPostSubscriberUseCase addPostSubscriberUseCase;
  final DeletePostSubscriberUseCase deletePostSubscriberUseCase;

  final AddSubscriberUseCase addSubscriberUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;
  final GetSubscribersUseCase getSubscribersUseCase;

  final AddEmojiUseCase addEmojiUseCase;
  final DeleteEmojiUseCase deleteEmojiUseCase;

  final AddCommentEmojiUseCase addCommentEmojiUseCase;
  final DeleteCommentEmojiUseCase deleteCommentEmojiUseCase;

  final GetAllPostsUseCase getAllPostsUseCase;
  final GetHomePostsUseCase getHomePostsUseCase;
  final SearchPostUseCase searchPostUseCase;

  final SendPostNotificationUseCase sendPostNotificationUseCase;
  final SendGeneralNotificationUseCase sendGeneralNotificationUseCase;

  final GetPostDataUseCase getPostDataUseCase;

  static HomePageCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> getAllPosts(GetPostsRequest getPostsRequest) async {
    emit(GetAllPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getAllPostsUseCase.call(getPostsRequest);
      result.fold(
            (failure) => emit(GetAllPostsErrorState(failure.message)),
            (posts) => emit(GetAllPostsSuccessState(posts)),
      );
    } else {
      emit(HomePageNoInternetState());
    }
  }

  Future<void> getHomePosts(GetPostsRequest getPostsRequest) async {
    emit(GetHomePostsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getHomePostsUseCase.call(getPostsRequest);
      result.fold(
            (failure) => emit(GetHomePostsErrorState(failure.message)),
            (posts) => emit(GetHomePostsSuccessState(posts)),
      );
    } else {
      emit(HomePageNoInternetState());
    }
  }

  Future<void> getHomePostsAndScrollToTop(GetPostsRequest getPostsRequest) async {
    emit(GetHomePostsAndScrollToTopLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getHomePostsUseCase.call(getPostsRequest);
      result.fold(
            (failure) => emit(GetHomePostsAndScrollToTopErrorState(failure.message)),
            (posts) => emit(GetHomePostsAndScrollToTopSuccessState(posts)),
      );
    } else {
      emit(HomePageNoInternetState());
    }
  }

  Future<void> searchPost(String postText) async {
    emit(SearchPostLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await searchPostUseCase.call(postText);
      result.fold(
            (failure) => emit(SearchPostErrorState(failure.message)),
            (posts) => emit(SearchPostSuccessState(posts)),
      );
    } else {
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
    }
  }

  Future<void> getSubscribers(GetSubscribersRequest getSubscribersRequest) async {
    emit(GetSubscribersLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getSubscribersUseCase.call(getSubscribersRequest);
      result.fold(
            (failure) => emit(GetSubscribersErrorState(failure.message)),
            (subscribers) => emit(GetSubscribersSuccessState(subscribers)),
      );
    } else {
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
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
      emit(HomePageNoInternetState());
    }
  }

  Future<void> getPostData(GetPostDataRequest getPostDataRequest) async {
    emit(GetPostDataLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getPostDataUseCase.call(getPostDataRequest);
      result.fold(
            (failure) => emit(GetPostDataErrorState(failure.message)),
            (posts) => emit(GetPostDataSuccessState(posts)),
      );
    } else {
      emit(HomePageNoInternetState());
    }
  }
}