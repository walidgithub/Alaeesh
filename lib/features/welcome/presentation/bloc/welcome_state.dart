import '../../data/model/user_model.dart';
import '../../data/model/user_permissions_model.dart';

abstract class WelcomeState{}

class WelcomeInitial extends WelcomeState{}

class LoginSuccessState extends WelcomeState{
  final UserModel user;

  LoginSuccessState(this.user);
}
class LoginErrorState extends WelcomeState{
  final String errorMessage;

  LoginErrorState(this.errorMessage);
}
class LoginLoadingState extends WelcomeState{}

class LogoutSuccessState extends WelcomeState{}
class LogoutErrorState extends WelcomeState{
  final String errorMessage;

  LogoutErrorState(this.errorMessage);
}
class LogoutLoadingState extends WelcomeState{}

class AddUserPermissionSuccessState extends WelcomeState{}
class AddUserPermissionErrorState extends WelcomeState{
  final String errorMessage;

  AddUserPermissionErrorState(this.errorMessage);
}
class AddUserPermissionLoadingState extends WelcomeState{}

class GetUserPermissionsLoadingState extends WelcomeState{}
class GetUserPermissionsSuccessState extends WelcomeState{
  UserPermissionsModel userPermissionsModel;
  GetUserPermissionsSuccessState(this.userPermissionsModel);
}
class GetUserPermissionsErrorState extends WelcomeState{
  final String errorMessage;

  GetUserPermissionsErrorState(this.errorMessage);
}

class WelcomeNoInternetState extends WelcomeState{}