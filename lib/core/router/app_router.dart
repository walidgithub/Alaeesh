import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:last/features/messages/presentation/bloc/messages_cubit.dart';
import 'package:last/features/switch_user/presentation/ui/switch_user_view.dart';
import 'package:last/features/trending/presentation/bloc/trending_cubit.dart';
import 'package:last/features/trending/presentation/ui/widgets/user_posts_view.dart';
import 'package:last/features/welcome/presentation/bloc/welcome_cubit.dart';
import '../../features/home_page/presentation/bloc/home_page_cubit.dart';
import '../../features/layout/presentation/ui/layout_view.dart';
import '../../features/mine/presentation/bloc/mine_cubit.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/welcome/presentation/ui/welcome_view.dart';
import '../di/di.dart';
import 'arguments.dart';

class Routes {
  static const String welcomeRoute = "/welcome";
  static const String layoutRoute = "/layout";
  static const String switchUserRoute = "/switchUser";
  static const String userPostsRoute = "/userPosts";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeRoute:
        return MaterialPageRoute(
            builder: (_) => Directionality(
                textDirection: TextDirection.rtl, child: const WelcomeView()));
      case Routes.layoutRoute:
        return MaterialPageRoute(
            builder: (_) => Directionality(
                textDirection: TextDirection.rtl, child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (homeContext) => sl<HomePageCubit>()),
                  BlocProvider(create: (trendingContext) => sl<TrendingCubit>()),
                  BlocProvider(create: (mineContext) => sl<MineCubit>()),
                  BlocProvider(create: (dashboardContext) => sl<DashboardCubit>()),
                  BlocProvider(create: (messagesContext) => sl<MessagesCubit>()),
                  BlocProvider(create: (notificationsContext) => sl<NotificationsCubit>()),
                  BlocProvider(create: (welcomeContext) => sl<WelcomeCubit>()),
                ],
                child: const LayoutView())));
      case Routes.switchUserRoute:
        return MaterialPageRoute(
            builder: (_) => Directionality(
                textDirection: TextDirection.rtl, child: const SwitchUserView()));
      case Routes.userPostsRoute:
        return MaterialPageRoute(
            builder: (_) => Directionality(
                textDirection: TextDirection.rtl, child: BlocProvider(create: (homeContext) => sl<HomePageCubit>(),child: UserPostsView(arguments: settings.arguments as UserPostsArguments))));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Container()),
    );
  }
}
