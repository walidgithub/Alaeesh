import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:last/features/dashboard/data/data_source/dashboard_datasource.dart';
import 'package:last/features/dashboard/data/repository_impl/dashboard_repository_impl.dart';
import 'package:last/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:last/features/dashboard/domain/usecases/get_user_advices_usecase.dart';
import 'package:last/features/dashboard/domain/usecases/send_reply_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_home_posts_usecase.dart';
import 'package:last/features/notifications/domain/usecases/update_notification_to_seen_usecase.dart';
import 'package:last/features/welcome/domain/usecases/update_user_permissions_usecase.dart';
import 'package:last/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:last/features/home_page/data/data_source/home_page_datasource.dart';
import 'package:last/features/home_page/data/repository_impl/home_page_repository_impl.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/add_post_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_emoji_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_post_usecase.dart';
import 'package:last/features/home_page/domain/usecases/delete_post_subscriber_usecase.dart';
import 'package:last/features/home_page/domain/usecases/get_all_posts_usecase.dart';
import 'package:last/features/home_page/domain/usecases/search_post_usecase.dart';
import 'package:last/features/messages/domain/repository/messgaes_repository.dart';
import 'package:last/features/messages/domain/usecases/get_unseen_messages_usecase.dart';
import 'package:last/features/messages/presentation/bloc/messages_cubit.dart';
import 'package:last/features/notifications/domain/repository/notifications_repository.dart';
import 'package:last/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:last/features/trending/data/data_source/trending_datasource.dart';
import 'package:last/features/trending/data/repository_impl/trending_repository_impl.dart';
import 'package:last/features/trending/domain/repository/trending_repository.dart';
import 'package:last/features/trending/domain/usecases/get_suggested_user_posts_usecase.dart';
import 'package:last/features/trending/domain/usecases/get_top_posts_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_comment_usecase.dart';
import 'package:last/features/home_page/domain/usecases/update_post_usecase.dart';
import 'package:last/features/home_page/presentation/bloc/home_page_cubit.dart';
import 'package:last/features/switch_user/data/data_source/switch_user_datasource.dart';
import 'package:last/features/switch_user/domain/repository/switch_user_repository.dart';
import 'package:last/features/switch_user/presentation/bloc/switch_user_cubit.dart';
import 'package:last/features/trending/presentation/bloc/trending_cubit.dart';
import 'package:last/features/welcome/data/data_source/welcome_datasource.dart';
import 'package:last/features/welcome/domain/repository/welcome_repository.dart';
import 'package:last/features/welcome/domain/usecases/logout_usecase.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/preferences/app_pref.dart';
import '../../features/home_page/domain/repository/home_page_repository.dart';
import '../../features/home_page/domain/usecases/add_subscriber_usecase.dart';
import '../../features/home_page/domain/usecases/delete_subscriber_usecase.dart';
import '../../features/home_page/domain/usecases/get_subscribers_usecase.dart';
import '../../features/layout/data/data_source/layout_datasource.dart';
import '../../features/layout/data/repository_impl/layout_repository_impl.dart';
import '../../features/layout/domain/repository/layout_repository.dart';
import '../../features/layout/domain/usecases/add_post_usecase.dart';
import '../../features/notifications/domain/usecases/get_unseen_notifications_usecase.dart';
import '../../features/welcome/domain/usecases/get_user_permissions_usecase.dart';
import '../../features/layout/domain/usecases/send_advise_usecase.dart';
import '../../features/layout/presentation/bloc/layout_cubit.dart';
import '../../features/messages/data/data_source/messages_datasource.dart';
import '../../features/messages/data/repository_impl/messages_repository_impl.dart';
import '../../features/messages/domain/usecases/get_messages_usecase.dart';
import '../../features/messages/domain/usecases/update_message_to_seen_usecase.dart';
import '../../features/mine/data/datasource/mine_datasource.dart';
import '../../features/mine/data/repository_impl/mine_repository_impl.dart';
import '../../features/mine/domain/repository/mine_repository.dart';
import '../../features/mine/domain/usecases/get_mine_usecase.dart';
import '../../features/mine/presentation/bloc/mine_cubit.dart';
import '../../features/notifications/data/data_source/notifications_datasource.dart';
import '../../features/notifications/data/repository_impl/notifications_repository_impl.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/switch_user/data/repository_impl/switch_user_repository_impl.dart';
import '../../features/switch_user/domain/usecases/switch_user_usecase.dart';
import '../../features/trending/domain/usecases/check_if_user_subscribed_usecase.dart';
import '../../features/trending/domain/usecases/get_suggested_users_usecase.dart';
import '../../features/welcome/data/repository_impl/welcome_repository_impl.dart';
import '../../features/welcome/domain/usecases/add_user_permissions_usecase.dart';
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
    sl.registerLazySingleton<SwitchUserDataSource>(() => SwitchUserDataSource());
    sl.registerLazySingleton<TrendingDataSource>(() => TrendingDataSource());
    sl.registerLazySingleton<MineDataSource>(() => MineDataSource());
    sl.registerLazySingleton<NotificationsDataSource>(() => NotificationsDataSource());
    sl.registerLazySingleton<DashboardDataSource>(() => DashboardDataSource());
    sl.registerLazySingleton<MessagesDataSource>(() => MessagesDataSource());

    // Repositories
    sl.registerLazySingleton<WelcomeRepository>(() => WelcomeRepositoryImpl(sl()));
    sl.registerLazySingleton<LayoutRepository>(() => LayoutRepositoryImpl(sl()));
    sl.registerLazySingleton<HomePageRepository>(() => HomePageRepositoryImpl(sl()));
    sl.registerLazySingleton<SwitchUserRepository>(() => SwitchUserRepositoryImpl(sl()));
    sl.registerLazySingleton<TrendingRepository>(() => TrendingRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<MineRepository>(() => MineRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(sl()));
    sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(sl(), sl(), sl()));
    sl.registerLazySingleton<MessagesRepository>(() => MessagesRepositoryImpl(sl()));

    // UseCases
    // welcome useCases
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
    sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
    sl.registerLazySingleton<AddUserPermissionsUseCase>(() => AddUserPermissionsUseCase(sl()));
    sl.registerLazySingleton<GetUserPermissionsUseCase>(() => GetUserPermissionsUseCase(sl()));
    sl.registerLazySingleton<UpdateUserPermissionsUseCase>(() => UpdateUserPermissionsUseCase(sl()));

    // switch user useCases
    sl.registerLazySingleton<SwitchUserUseCase>(() => SwitchUserUseCase(sl()));

    // layout useCases
    sl.registerLazySingleton<AddPostUseCase>(() => AddPostUseCase(sl()));
    sl.registerLazySingleton<SendAdviceUseCase>(() => SendAdviceUseCase(sl()));

    // homepage useCases
    sl.registerLazySingleton<AddCommentUseCase>(() => AddCommentUseCase(sl()));
    sl.registerLazySingleton<DeleteCommentUseCase>(() => DeleteCommentUseCase(sl()));
    sl.registerLazySingleton<UpdateCommentUseCase>(() => UpdateCommentUseCase(sl()));

    sl.registerLazySingleton<AddPostSubscriberUseCase>(() => AddPostSubscriberUseCase(sl()));
    sl.registerLazySingleton<DeletePostSubscriberUseCase>(() => DeletePostSubscriberUseCase(sl()));

    sl.registerLazySingleton<AddSubscriberUseCase>(() => AddSubscriberUseCase(sl()));
    sl.registerLazySingleton<DeleteSubscriberUseCase>(() => DeleteSubscriberUseCase(sl()));
    sl.registerLazySingleton<GetSubscribersUseCase>(() => GetSubscribersUseCase(sl()));

    sl.registerLazySingleton<AddEmojiUseCase>(() => AddEmojiUseCase(sl()));
    sl.registerLazySingleton<DeleteEmojiUseCase>(() => DeleteEmojiUseCase(sl()));

    sl.registerLazySingleton<DeletePostUseCase>(() => DeletePostUseCase(sl()));
    sl.registerLazySingleton<UpdatePostUseCase>(() => UpdatePostUseCase(sl()));

    sl.registerLazySingleton<AddCommentEmojiUseCase>(() => AddCommentEmojiUseCase(sl()));
    sl.registerLazySingleton<DeleteCommentEmojiUseCase>(() => DeleteCommentEmojiUseCase(sl()));

    sl.registerLazySingleton<GetAllPostsUseCase>(() => GetAllPostsUseCase(sl()));
    sl.registerLazySingleton<GetHomePostsUseCase>(() => GetHomePostsUseCase(sl()));
    sl.registerLazySingleton<SearchPostUseCase>(() => SearchPostUseCase(sl()));

    // trending useCases
    sl.registerLazySingleton<GetTopPostsUseCase>(() => GetTopPostsUseCase(sl()));
    sl.registerLazySingleton<GetSuggestedUsersUseCase>(() => GetSuggestedUsersUseCase(sl()));
    sl.registerLazySingleton<GetSuggestedUserPostsUseCase>(() => GetSuggestedUserPostsUseCase(sl()));
    sl.registerLazySingleton<CheckIfUserSubscribedUseCase>(() => CheckIfUserSubscribedUseCase(sl()));

    // mine useCases
    sl.registerLazySingleton<GetMineUseCase>(() => GetMineUseCase(sl()));

    // notifications useCases
    sl.registerLazySingleton<GetNotificationsUseCase>(() => GetNotificationsUseCase(sl()));
    sl.registerLazySingleton<GetUnSeenNotificationsUseCase>(() => GetUnSeenNotificationsUseCase(sl()));
    sl.registerLazySingleton<UpdateNotificationToSeenUseCase>(() => UpdateNotificationToSeenUseCase(sl()));

    // dashboard useCases
    sl.registerLazySingleton<GetUserAdvicesUseCase>(() => GetUserAdvicesUseCase(sl()));
    sl.registerLazySingleton<SendReplyUseCase>(() => SendReplyUseCase(sl()));

    // messages useCases
    sl.registerLazySingleton<GetMessagesUseCase>(() => GetMessagesUseCase(sl()));
    sl.registerLazySingleton<GetUnSeenMessagesUseCase>(() => GetUnSeenMessagesUseCase(sl()));
    sl.registerLazySingleton<UpdateMessageToSeenUseCase>(() => UpdateMessageToSeenUseCase(sl()));

    // Bloc
    sl.registerFactory(() => SwitchUserCubit(sl(), sl(), sl()));
    sl.registerFactory(() => WelcomeCubit(sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => LayoutCubit(sl(), sl()));
    sl.registerFactory(() => NotificationsCubit(sl(), sl(), sl()));
    sl.registerFactory(() => TrendingCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => HomePageCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => MineCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => DashboardCubit(sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerFactory(() => MessagesCubit(sl(), sl(), sl()));
  }
}