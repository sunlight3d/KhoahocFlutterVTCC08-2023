import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/blocs/app_bloc_observer.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/tasks/cubit.dart';
import 'package:myapp/databases/sqlite_db_helper.dart';
import 'package:myapp/screens/Location/index.dart';
import 'package:myapp/screens/camera_scan/index.dart';
import 'package:myapp/screens/home/index.dart';
import 'package:myapp/screens/nfc_scanning_guide/index.dart';
import 'package:myapp/screens/profile/index.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/screens/settings/index.dart';
import 'package:myapp/services/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => UserService());//like AddServices in .net core mvc
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => SQLiteDBHelper());
}

/*
Detail user: https://randomuser.me/api/

* */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  setupLocator(); // Đảm bảo gọi hàm setupLocator trước runApp
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('vi', 'VN')
      ], // Danh sách ngôn ngữ được hỗ trợ
      path: 'assets/languages', // Thư mục chứa tệp dịch (`.json`)
      //fallbackLocale: Locale('en', 'US'), // Ngôn ngữ mặc định
      fallbackLocale: Locale('vi', 'VN'), // Ngôn ngữ mặc định
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingCubit>(
            create: (context) => SettingCubit(),
          ),
          BlocProvider<TaskCubit>(
            create: (context) => TaskCubit(),
          ),
          // ... Các BlocProvider khác nếu có
        ],
        child: MyApp(),
        //Google Maps, lat long location
      ), // Thay thế MyApp() bằng tên ứng dụng của bạn
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      //locale: context.locale,
      locale: context.supportedLocales[1],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: NFCScanningGuide(),
      //home: CameraScan()
      //home: Profile()
      home: HomeScreen(),
      //home: LocationScreen(),
      // Thêm Routes để định nghĩa đường dẫn đến SettingsScreen
      routes: {
        '/settings': (context) => SettingsScreen(),
        '/location': (context) => LocationScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

