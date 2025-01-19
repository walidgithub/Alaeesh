import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/layout/domain/usecases/add_post_usecase.dart';
import 'package:last/features/layout/domain/usecases/get_user_permissions_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../../data/model/requests/send_advise_request.dart';
import '../../domain/usecases/send_advise_usecase.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(this.addPostUseCase, this.sendAdviseUseCase, this.getUserPermissionsUseCase) : super(LayoutInitial());

  final AddPostUseCase addPostUseCase;
  final SendAdviseUseCase sendAdviseUseCase;
  final GetUserPermissionsUseCase getUserPermissionsUseCase;

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
      emit(NoInternetState());
    }
  }

  Future<void> sendAdvise(SendAdviseRequest sendAdviseRequest) async {
    emit(SendAdviseLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendAdviseUseCase.call(sendAdviseRequest);
      result.fold(
            (failure) => emit(SendAdviseErrorState(failure.message)),
            (adviseSent) => emit(SendAdviseSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> getUserPermissions(UserPermissionsModel userPermissionsModel) async {
    emit(GetUserPermissionsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getUserPermissionsUseCase.call(userPermissionsModel);
      result.fold(
            (failure) => emit(GetUserPermissionsErrorState(failure.message)),
            (userPermissions) => emit(GetUserPermissionsSuccessState(userPermissions)),
      );
    } else {
      emit(NoInternetState());
    }
  }
}