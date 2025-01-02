import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/core/base_usecase/firebase_base_usecase.dart';
import 'package:last/features/switch_user/presentation/bloc/switch_user_states.dart';
import 'package:last/features/welcome/domain/usecases/login_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/usecases/switch_user_usecase.dart';

class SwitchUserCubit extends Cubit<SwitchUserState> {
  SwitchUserCubit(this.switchUserUseCase) : super(SwitchUserInitial());

  final SwitchUserUseCase switchUserUseCase;

  static SwitchUserCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> switchUser() async {
    emit(SwitchUserLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await switchUserUseCase.call(const FirebaseNoParameters());
      signInResult.fold(
            (failure) => emit(SwitchUserErrorState(failure.message)),
            (user) => emit(SwitchUserSuccessState(user)),
      );
    } else {
      emit(NoInternetState());
    }
  }
}
