import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/preferences/app_pref.dart';
import '../network/network_info.dart';


final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    // app prefs instance
    final sharedPrefs = await SharedPreferences.getInstance();

    sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

    sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

    // Network Info
    sl.registerLazySingleton<NetworkInfo>(
            () => NetworkInfoImpl(InternetConnectionChecker()));

    // DataSources
    // sl.registerLazySingleton<AuthDataSource>(() => AuthDataSource());

    // Repositories
    // sl.registerLazySingleton<FirebaseRepository>(() => AuthRepository(sl(), sl()));

    // UseCases
    // sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

    // Bloc
    // sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));
  }
}