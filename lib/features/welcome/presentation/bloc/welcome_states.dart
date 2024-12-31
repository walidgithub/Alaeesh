import '../../data/model/user_model.dart';

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

class NoInternetState extends WelcomeState{}