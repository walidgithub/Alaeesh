import 'package:flutter/material.dart';
import '../../features/layout/ui/layout_view.dart';
import '../../features/welcome/presentation/ui/welcome_view.dart';

class Routes {
  static const String welcomeRoute = "/welcome";
  static const String layoutRoute = "/layout";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case Routes.layoutRoute:
        return MaterialPageRoute(builder: (_) => const LayoutView());
      // case Routes.weatherRoute:
      //   return MaterialPageRoute(builder: (_) => WeatherView(arguments: settings.arguments as WeatherViewArguments));
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
