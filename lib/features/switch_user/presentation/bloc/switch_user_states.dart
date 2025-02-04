import '../../../welcome/data/model/user_model.dart';
import '../../../welcome/data/model/user_permissions_model.dart';

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

class AddUserPermissionSuccessState extends SwitchUserState{}
class AddUserPermissionErrorState extends SwitchUserState{
  final String errorMessage;

  AddUserPermissionErrorState(this.errorMessage);
}
class AddUserPermissionLoadingState extends SwitchUserState{}

class GetUserPermissionsLoadingState extends SwitchUserState{}
class GetUserPermissionsSuccessState extends SwitchUserState{
  UserPermissionsModel userPermissionsModel;
  GetUserPermissionsSuccessState(this.userPermissionsModel);
}
class GetUserPermissionsErrorState extends SwitchUserState{
  final String errorMessage;

  GetUserPermissionsErrorState(this.errorMessage);
}

class SwitchUserNoInternetState extends SwitchUserState{}