import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/messages/presentation/bloc/messages_cubit.dart';
import 'package:last/features/messages/presentation/ui/widgets/message_view.dart';

import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../../../../core/utils/dialogs/error_dialog.dart';
import '../../../../core/utils/style/app_colors.dart';
import '../../../../core/utils/ui_components/loading_dialog.dart';
import '../../../../core/utils/ui_components/snackbar.dart';
import '../../data/model/messages_model.dart';
import '../../data/model/requests/get_messages_request.dart';
import '../bloc/messages_state.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

  String id = "";
  String email = "";
  String displayName = "";
  String photoUrl = "";
  var userData;

  @override
  void initState() {
    userData = _appSecureDataHelper.loadUserData();
    _loadSavedUserData();
    super.initState();
  }

  Future<void> refreshLastPosts() async {
    setState(() {
      MessagesCubit.get(context).getUserMessages(GetMessagesRequest(username: displayName));
    });
  }

  Future<void> _loadSavedUserData() async {
    userData = await _appSecureDataHelper.loadUserData();
    setState(() {
      id = userData['id'] ?? '';
      email = userData['email'] ?? '';
      displayName = userData['displayName'] ?? '';
      photoUrl = userData['photoUrl'] ?? '';
    });
    getMessages();
  }

  getMessages() {
    MessagesCubit.get(context).getUserMessages(GetMessagesRequest(username: displayName));
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
        child: Scaffold(
          body: bodyContent(context, statusBarHeight),
        ));
  }

  Widget bodyContent(BuildContext context, double statusBarHeight) {
    return Column(children: [
      Expanded(
        child: BlocConsumer<MessagesCubit, MessagesState>(
          listener: (context, state) {
            if (state is GetMessagesLoadingState) {
              showLoading();
            } else if (state is GetMessagesSuccessState) {
              hideLoading();
              messagesModel.clear();
              messagesModel.addAll(state.messagesList);
            } else if (state is GetMessagesErrorState) {
              hideLoading();
              showSnackBar(context, state.errorMessage);
            } else if (state is NoInternetState) {
              hideLoading();
              onError(context, AppStrings.noInternet);
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.cTitle,
              backgroundColor: AppColors.cWhite,
              onRefresh: refreshLastPosts,
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MessageView(
                      statusBarHeight: statusBarHeight,
                      id: messagesModel[index].id!,
                      username: messagesModel[index].username,
                      time: messagesModel[index].time,
                      message: messagesModel[index].message,
                      seen: messagesModel[index].seen,
                    );
                  },
                  itemCount: messagesModel.length),
            );
          },
        ),
      )
    ],);
  }
}
