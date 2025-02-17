import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/dashboard/data/model/requests/send_reply_request.dart';
import 'package:last/features/dashboard/domain/usecases/add_user_usecase.dart';
import 'package:last/features/dashboard/domain/usecases/get_user_advices_usecase.dart';
import 'package:last/features/dashboard/domain/usecases/send_reply_usecase.dart';
import '../../../../core/base_usecase/firebase_base_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/requests/delete_comment_request.dart';
import '../../../home_page/data/model/requests/delete_post_subscriber_request.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../home_page/domain/usecases/delete_comment_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_subscriber_usecase.dart';
import '../../../home_page/domain/usecases/delete_post_usecase.dart';
import '../../../home_page/domain/usecases/get_all_posts_usecase.dart';
import '../../data/model/user_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.sendReplyUseCase, this.addUserUseCase, this.getUserAdvicesUseCase, this.deletePostUseCase, this.deleteCommentUseCase, this.deletePostSubscriberUseCase, this.getAllPostsUseCase)
      : super(DashboardInitial());

  final DeletePostUseCase deletePostUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final DeletePostSubscriberUseCase deletePostSubscriberUseCase;
  final SendReplyUseCase sendReplyUseCase;
  final AddUserUseCase addUserUseCase;

  final GetAllPostsUseCase getAllPostsUseCase;
  final GetUserAdvicesUseCase getUserAdvicesUseCase;



  static DashboardCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> deletePost(String postId) async {
    emit(DeletePostLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await deletePostUseCase.call(postId);
      result.fold(
            (failure) => emit(DeletePostErrorState(failure.message)),
            (postDeleted) => emit(DeletePostSuccessState()),
      );
    } else {
      emit(DashboardNoInternetState());
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
      emit(DashboardNoInternetState());
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
      emit(DashboardNoInternetState());
    }
  }

  Future<void> getAllPosts(GetPostsRequest getPostsRequest) async {
    emit(GetAllPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getAllPostsUseCase.call(getPostsRequest);
      result.fold(
            (failure) => emit(GetAllPostsErrorState(failure.message)),
            (posts) => emit(GetAllPostsSuccessState(posts)),
      );
    } else {
      emit(DashboardNoInternetState());
    }
  }

  Future<void> getUserAdvices() async {
    emit(GetUserAdvicesLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getUserAdvicesUseCase.call(const FirebaseNoParameters());
      result.fold(
            (failure) => emit(GetUserAdvicesErrorState(failure.message)),
            (userAdvices) => emit(GetUserAdvicesSuccessState(userAdvices)),
      );
    } else {
      emit(DashboardNoInternetState());
    }
  }

  Future<void> sendReply(SendReplyRequest sendReplyRequest) async {
    emit(DashboardSendReplyLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendReplyUseCase.call(sendReplyRequest);
      result.fold(
            (failure) => emit(DashboardSendReplyErrorState(failure.message)),
            (replySent) => emit(DashboardSendReplySuccessState()),
      );
    } else {
      emit(DashboardNoInternetState());
    }
  }

  Future<void> addUser(AllowedUserModel allowedUserModel) async {
    emit(AddUserLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await addUserUseCase.call(allowedUserModel);
      result.fold(
            (failure) => emit(AddUserErrorState(failure.message)),
            (userAdded) => emit(AddUserSuccessState()),
      );
    } else {
      emit(DashboardNoInternetState());
    }
  }
}