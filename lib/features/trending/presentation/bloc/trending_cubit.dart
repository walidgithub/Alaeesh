import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/domain/usecases/get_suggested_user_posts_usecase.dart';
import 'package:last/features/trending/presentation/bloc/trending_state.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/requests/add_subscriber_request.dart';
import '../../../home_page/data/model/requests/delete_subscriber_request.dart';
import '../../../home_page/domain/usecases/add_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/delete_subscriber_usecase.dart';
import '../../data/model/requests/get_post_data_request.dart';
import '../../data/model/requests/get_top_posts_request.dart';
import '../../domain/usecases/get_suggested_users_usecase.dart';
import '../../domain/usecases/get_top_posts_usecase.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit(
      this.getTopPostsUseCase, this.getSuggestedUsersUseCase, this.getSuggestedUserPostsUseCase, this.addSubscriberUseCase, this.deleteSubscriberUseCase)
      : super(TrendingInitial());

  final GetTopPostsUseCase getTopPostsUseCase;
  final GetSuggestedUsersUseCase getSuggestedUsersUseCase;
  final GetSuggestedUserPostsUseCase getSuggestedUserPostsUseCase;
  final AddSubscriberUseCase addSubscriberUseCase;
  final DeleteSubscriberUseCase deleteSubscriberUseCase;

  static TrendingCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> getTopPosts(GetTopPostsRequest getTopPostsRequest) async {
    emit(GetTopPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getTopPostsUseCase.call(getTopPostsRequest);
      signInResult.fold(
            (failure) => emit(GetTopPostsErrorState(failure.message)),
            (posts) => emit(GetTopPostsSuccessState(posts)),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> getSuggestedUsers() async {
    emit(GetSuggestedUsersLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getSuggestedUsersUseCase.call(const FirebaseNoParameters());
      signInResult.fold(
            (failure) => emit(GetSuggestedUsersErrorState(failure.message)),
            (suggestedUsers) => emit(GetSuggestedUsersSuccessState(suggestedUsers)),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> getSuggestedUserPosts(GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    emit(GetSuggestedUserPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getSuggestedUserPostsUseCase.call(getSuggestedUserPostsRequest);
      signInResult.fold(
            (failure) => emit(GetSuggestedUserPostsErrorState(failure.message)),
            (suggestedUserPosts) => emit(GetSuggestedUserPostsSuccessState(suggestedUserPosts)),
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
            (subscriberAdded) => emit(AddSubscriberSuccessState()),
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
            (subscriberDeleted) => emit(DeleteSubscriberSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }
}