import 'package:shared_preferences/shared_preferences.dart';

const String userLoggedIn = "userLoggedIn";
const String userEmail = "userEmail";
const String userName = "userName";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  //login
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(userLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(userLoggedIn) ?? false;
  }

  Future<void> setUserLoggedOut() async {
    _sharedPreferences.remove(userLoggedIn);
  }
}
