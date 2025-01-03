import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/welcome/domain/usecases/login_usecase.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_states.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/usecases/logout_usecase.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this.loginUseCase, this.logoutUseCase) : super(WelcomeInitial());

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  static WelcomeCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> login() async {
    emit(LoginLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await loginUseCase.call(const FirebaseNoParameters());
      signInResult.fold(
            (failure) => emit(LoginErrorState(failure.message)),
            (user) => emit(LoginSuccessState(user)),
      );
    } else {
      emit(NoInternetState());
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
      emit(NoInternetState());
    }
  }
}
