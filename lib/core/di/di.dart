import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:last/features/home_page/data/data_source/home_page_datasource.dart';
import 'package:last/features/home_page/data/model/requests/update_comment_request.dart';
import 'package:last/features/home_page/data/repository_impl/home_page_repository_impl.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_post_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_all_posts_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_top_posts_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_post_usecase.dart';
import 'package:last/features/home_page/presentation/bloc/home_page_cubit.dart';
import 'package:last/features/layout/ui/bloc/layout_cubit.dart';
import 'package:last/features/welcome/data/data_source/welcome_datasource.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';
import 'package:last/features/welcome/domain/usecases/logout_usecase.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/preferences/app_pref.dart';
import '../../features/home_page/domain/repository/home_page_repository.dart';
import '../../features/layout/data/data_source/layout_datasource.dart';
import '../../features/layout/data/repository_impl/layout_repository_impl.dart';
import '../../features/layout/domain/repository/layout_repository.dart';
import '../../features/layout/domain/usecases/add_post_usecase.dart';
import '../../features/layout/domain/usecases/delete_notification_usecase.dart';
import '../../features/layout/domain/usecases/get_notifications_usecase.dart';
import '../../features/welcome/data/repository_impl/welcome_repository_impl.dart';
import '../../features/welcome/domain/usecases/login_usecase.dart';
import '../network/network_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../preferences/secure_local_data.dart';


final sl = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    // app prefs instance
    final sharedPrefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
    sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

    // Secure local data
    final secureStorage = FlutterSecureStorage();
    sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
    sl.registerLazySingleton<SecureStorageLoginHelper>(() => SecureStorageLoginHelper(sl()));

    // Firebase Auth
    final auth = FirebaseAuth.instance;
    sl.registerLazySingleton<FirebaseAuth>(() => auth);

    final firestore = FirebaseFirestore.instance;
    sl.registerLazySingleton<FirebaseFirestore>(() => firestore);

    // Network Info
    sl.registerLazySingleton<NetworkInfo>(
            () => NetworkInfoImpl(InternetConnectionChecker()));

    // DataSources
    sl.registerLazySingleton<WelcomeDataSource>(() => WelcomeDataSource());
    sl.registerLazySingleton<LayoutDataSource>(() => LayoutDataSource());
    sl.registerLazySingleton<HomePageDataSource>(() => HomePageDataSource());

    // Repositories
    sl.registerLazySingleton<WelcomeRepository>(() => WelcomeRepositoryImpl(sl()));
    sl.registerLazySingleton<LayoutRepository>(() => LayoutRepositoryImpl(sl()));
    sl.registerLazySingleton<HomePageRepository>(() => HomePageRepositoryImpl(sl()));

    // UseCases
    // welcome useCases
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
    // layout useCases
    sl.registerLazySingleton<AddPostUseCase>(() => AddPostUseCase(sl()));
    sl.registerLazySingleton<DeleteNotificationUseCase>(() => DeleteNotificationUseCase(sl()));
    sl.registerLazySingleton<GetAllNotificationsUseCase>(() => GetAllNotificationsUseCase(sl()));
    // homepage useCases
    sl.registerLazySingleton<AddCommentUseCase>(() => AddCommentUseCase(sl()));
    sl.registerLazySingleton<DeleteCommentUseCase>(() => DeleteCommentUseCase(sl()));
    sl.registerLazySingleton<UpdateCommentUseCase>(() => UpdateCommentUseCase(sl()));

    sl.registerLazySingleton<AddSubscriberUseCase>(() => AddSubscriberUseCase(sl()));
    sl.registerLazySingleton<DeleteSubscriberUseCase>(() => DeleteSubscriberUseCase(sl()));

    sl.registerLazySingleton<AddEmojiUseCase>(() => AddEmojiUseCase(sl()));
    sl.registerLazySingleton<DeleteEmojiUseCase>(() => DeleteEmojiUseCase(sl()));

    sl.registerLazySingleton<DeletePostUseCase>(() => DeletePostUseCase(sl()));
    sl.registerLazySingleton<UpdatePostUseCase>(() => UpdatePostUseCase(sl()));

    sl.registerLazySingleton<AddCommentEmojiUseCase>(() => AddCommentEmojiUseCase(sl()));
    sl.registerLazySingleton<DeleteCommentEmojiUseCase>(() => DeleteCommentEmojiUseCase(sl()));

    sl.registerLazySingleton<GetAllPostsUseCase>(() => GetAllPostsUseCase(sl()));
    sl.registerLazySingleton<GetTopPostsUseCase>(() => GetTopPostsUseCase(sl()));

    // Bloc
    sl.registerFactory(() => WelcomeCubit(sl(), sl()));
    sl.registerFactory(() => LayoutCubit(sl(), sl(), sl()));
    sl.registerFactory(() => HomePageCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  }
}