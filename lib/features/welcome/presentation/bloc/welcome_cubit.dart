import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/welcome/domain/usecases/login_usecase.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_states.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../data/model/user_permissions_model.dart';
import '../../domain/usecases/add_user_permissions_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this.loginUseCase, this.logoutUseCase, this.addUserPermissionsUseCase) : super(WelcomeInitial());

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AddUserPermissionsUseCase addUserPermissionsUseCase;

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
            (loggedOut) => emit(AddUserPermissionSuccessState()),
      );
    } else {
      emit(WelcomeNoInternetState());
    }
  }
}
