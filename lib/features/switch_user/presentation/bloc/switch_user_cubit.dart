import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/switch_user/presentation/bloc/switch_user_states.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../welcome/data/model/user_permissions_model.dart';
import '../../../welcome/domain/usecases/add_user_permissions_usecase.dart';
import '../../../welcome/domain/usecases/get_user_permissions_usecase.dart';
import '../../domain/usecases/switch_user_usecase.dart';

class SwitchUserCubit extends Cubit<SwitchUserState> {
  SwitchUserCubit(this.switchUserUseCase, this.addUserPermissionsUseCase, this.getUserPermissionsUseCase) : super(SwitchUserInitial());

  final SwitchUserUseCase switchUserUseCase;
  final AddUserPermissionsUseCase addUserPermissionsUseCase;
  final GetUserPermissionsUseCase getUserPermissionsUseCase;

  static SwitchUserCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> switchUser() async {
    emit(SwitchUserLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await switchUserUseCase.call(const FirebaseNoParameters());
      result.fold(
            (failure) => emit(SwitchUserErrorState(failure.message)),
            (user) => emit(SwitchUserSuccessState(user)),
      );
    } else {
      emit(SwitchUserNoInternetState());
    }
  }

  Future<void> addUserPermission(UserPermissionsModel userPermissionsModel) async {
    emit(AddUserPermissionLoadingState());
    if (await _networkInfo.isConnected) {
      final signOutResult = await addUserPermissionsUseCase.call(userPermissionsModel);
      signOutResult.fold(
            (failure) => emit(AddUserPermissionErrorState(failure.message)),
            (userPermissionAdded) => emit(AddUserPermissionSuccessState()),
      );
    } else {
      emit(SwitchUserNoInternetState());
    }
  }

  Future<void> getUserPermissions(String username) async {
    emit(GetUserPermissionsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getUserPermissionsUseCase.call(username);
      result.fold(
            (failure) => emit(GetUserPermissionsErrorState(failure.message)),
            (userPermissions) => emit(GetUserPermissionsSuccessState(userPermissions)),
      );
    } else {
      emit(SwitchUserNoInternetState());
    }
  }
}
