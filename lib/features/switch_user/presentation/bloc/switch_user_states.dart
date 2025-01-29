import '../../../welcome/data/model/user_model.dart';

abstract class SwitchUserState{}

class SwitchUserInitial extends SwitchUserState{}

class SwitchUserSuccessState extends SwitchUserState{
  final UserModel user;

  SwitchUserSuccessState(this.user);
}
class SwitchUserErrorState extends SwitchUserState{
  final String errorMessage;

  SwitchUserErrorState(this.errorMessage);
}
class SwitchUserLoadingState extends SwitchUserState{}

class SwitchUserNoInternetState extends SwitchUserState{}