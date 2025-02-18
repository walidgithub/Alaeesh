import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/welcome/domain/usecases/get_allowed_users_usecase.dart';
import 'package:last/features/welcome/domain/usecases/login_usecase.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_state.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../dashboard/data/model/requests/send_reply_request.dart';
import '../../../dashboard/domain/usecases/send_reply_usecase.dart';
import '../../data/model/user_permissions_model.dart';
import '../../domain/usecases/add_user_permissions_usecase.dart';
import '../../domain/usecases/get_user_permissions_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/update_user_permissions_usecase.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this.sendReplyUseCase, this.getAllowedUsersUseCase, this.updateUserPermissionsUseCase, this.loginUseCase, this.logoutUseCase, this.addUserPermissionsUseCase, this.getUserPermissionsUseCase) : super(WelcomeInitial());

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AddUserPermissionsUseCase addUserPermissionsUseCase;
  final GetUserPermissionsUseCase getUserPermissionsUseCase;
  final UpdateUserPermissionsUseCase updateUserPermissionsUseCase;
  final SendReplyUseCase sendReplyUseCase;
  final GetAllowedUsersUseCase getAllowedUsersUseCase;

  static WelcomeCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> login() async {
    emit(LoginLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await loginUseCase.call(const FirebaseNoParameters());
      result.fold(
            (failure) => emit(LoginErrorState(failure.message)),
            (user) => emit(LoginSuccessState(user)),
      );
    } else {
      emit(WelcomeNoInternetState());
    }
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    if (await _networkInfo.isConnected) {
      final signOutResult = await logoutUseCase.call(const FirebaseNoParameters());
      signOutResult.fold(
            (failure) => emit(LogoutErrorState(failure.message)),
            (loggedOut) => emit(LogoutSuccessState()),
      );
    } else {
      emit(WelcomeNoInternetState());
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
      emit(WelcomeNoInternetState());
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
      emit(WelcomeNoInternetState());
    }
  }

  Future<void> updateUserPermissions(UserPermissionsModel userPermissionsModel) async {
    emit(UpdateUserPermissionsLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await updateUserPermissionsUseCase.call(userPermissionsModel);
      result.fold(
            (failure) => emit(UpdateUserPermissionsErrorState(failure.message)),
            (userPermissionUpdated) => emit(UpdateUserPermissionsSuccessState()),
      );
    } else {
      emit(WelcomeNoInternetState());
    }
  }

  Future<void> sendReply(SendReplyRequest sendReplyRequest) async {
    emit(SendReplyLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await sendReplyUseCase.call(sendReplyRequest);
      result.fold(
            (failure) => emit(SendReplyErrorState(failure.message)),
            (replySent) => emit(SendReplySuccessState()),
      );
    } else {
      emit(WelcomeNoInternetState());
    }
  }

  Future<void> getAllowedUsers() async {
    emit(GetAllowedUsersLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getAllowedUsersUseCase.call(const FirebaseNoParameters());
      result.fold(
            (failure) => emit(GetAllowedUsersErrorState(failure.message)),
            (allowedUsers) => emit(GetAllowedUsersSuccessState(allowedUsers)),
      );
    } else {
      emit(WelcomeNoInternetState());
    }
  }
}
