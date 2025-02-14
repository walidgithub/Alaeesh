import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:last/core/preferences/app_pref.dart';
import 'package:last/core/utils/style/app_colors.dart';

import 'core/di/di.dart';
import 'core/router/app_router.dart';
import 'core/utils/constant/app_constants.dart';
import 'core/utils/constant/app_strings.dart';
import 'core/utils/style/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ServiceLocator().init();
  await ScreenUtil.ensureScreenSize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final isLoggedIn = await checkUserLoginStatus();

  // runApp(DevicePreview(builder: (context) => const MyApp()));
  runApp(MyApp(isLoggedIn: isLoggedIn));

  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
    body: SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                AppStrings.someThingWentWrong,
                style: TextStyle(color: AppColors.cPrimary),
              ),
              SizedBox(
                height: AppConstants.heightBetweenElements,
              ),
              Text(
                AppStrings.email,
                style: TextStyle(color: AppColors.cPrimary),
              ),
              SizedBox(
                height: AppConstants.heightBetweenElements,
              ),
              Text(
                details.exceptionAsString(),
                style: TextStyle(color: AppColors.cPrimary),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> checkUserLoginStatus() async {
  final AppPreferences appPreferences = sl<AppPreferences>();
  return appPreferences.isUserLoggedIn();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              builder: EasyLoading.init(),
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: isLoggedIn ? Routes.layoutRoute : Routes.welcomeRoute,
              theme: AppTheme.lightTheme);
        });
  }
}
