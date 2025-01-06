import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/trending/presentation/bloc/trending_state.dart';

import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../domain/usecases/get_top_posts_usecase.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit(
      this.getTopPostsUseCase)
      : super(TrendingInitial());

  final GetTopPostsUseCase getTopPostsUseCase;

  static TrendingCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();


  Future<void> getTopPosts(GetPostsRequest getPostsRequest) async {
    emit(GetTopPostsLoadingState());
    if (await _networkInfo.isConnected) {
      final signInResult = await getTopPostsUseCase.call(getPostsRequest);
      signInResult.fold(
            (failure) => emit(GetTopPostsErrorState(failure.message)),
            (posts) => emit(GetTopPostsSuccessState(posts)),
      );
    } else {
      emit(NoInternetState());
    }
  }
}