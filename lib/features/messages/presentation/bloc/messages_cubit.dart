import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/messages/domain/usecases/get_messages_usecase.dart';
import '../../../../core/di/di.dart';
import '../../../../core/network/network_info.dart';
import '../../data/model/requests/get_messages_request.dart';
import '../../data/model/requests/update_message_to_seeen_request.dart';
import '../../domain/usecases/update_message_to_seen_usecase.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this.getMessagesUseCase, this.updateMessageToSeenUseCase)
      : super(MessagesInitial());

  final GetMessagesUseCase getMessagesUseCase;
  final UpdateMessageToSeenUseCase updateMessageToSeenUseCase;

  static MessagesCubit get(context) => BlocProvider.of(context);

  final NetworkInfo _networkInfo = sl<NetworkInfo>();

  Future<void> getUserMessages(GetMessagesRequest getMessagesRequest) async {
    emit(GetMessagesLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await getMessagesUseCase.call(getMessagesRequest);
      result.fold(
            (failure) => emit(GetMessagesErrorState(failure.message)),
            (messages) => emit(GetMessagesSuccessState(messages)),
      );
    } else {
      emit(NoInternetState());
    }
  }

  Future<void> updateMessageToSeen(UpdateMessageToSeenRequest updateMessageToSeenRequest) async {
    emit(UpdateMessageToSeenLoadingState());
    if (await _networkInfo.isConnected) {
      final result = await updateMessageToSeenUseCase.call(updateMessageToSeenRequest);
      result.fold(
            (failure) => emit(UpdateMessageToSeenErrorState(failure.message)),
            (messageUpdated) => emit(UpdateMessageToSeenSuccessState()),
      );
    } else {
      emit(NoInternetState());
    }
  }
}