import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/blocs/app_bloc_observer.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/tasks/cubit.dart';
import 'package:myapp/databases/sqlite_db_helper.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/notification/local_notification.dart';
import 'package:myapp/screens/Location/index.dart';
import 'package:myapp/screens/camera_scan/index.dart';
import 'package:myapp/screens/home/index.dart';
import 'package:myapp/screens/nfc_scanning_guide/index.dart';
import 'package:myapp/screens/profile/index.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/screens/settings/index.dart';
import 'package:myapp/services/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => UserService());//like AddServices in .net core mvc
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => SQLiteDBHelper());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //auto-generate
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotification.initialize();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    LocalNotification.showNotification(message);
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  //lấy device's token để test FCM, với ios phải có real device
  FirebaseMessaging.instance.getToken().then((value) {
    String? token = value;
    print(token ?? "");
    //cTWM3ZscTYWJAnzi14zSsR:APA91bHQm3rtnAn8O4zKmyZj77VcgS_6AfD8EML3f8jUp5xwSxCyioi3aTtaGKJtCORQUB05y-n-ILScyj4O8IWfRkzG1saPr0gPTcEWWIxbrzQe_-3Wyz6c_XDqSND0uL3nkjv9Q-i3
  });

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
/*
flutter pub add firebase_messaging
flutter pub add flutter_local_notifications
flutter pub add firebase_core
flutter pub add firebase_analytics
Cài Firebase CLI:
https://firebase.google.com/docs/cli#mac-linux-auto-script

Làm theo hướng dẫn:
https://firebase.google.com/docs/flutter/setup?platform=ios#available-plugins
Trước khi Firebase Login, Google "Firebase Console", tạo Project Firebase trên web

firebase login
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub add firebase_core
flutterfire configure

Thêm plugins:
flutter pub add firebase_analytics
flutter pub add firebase_messaging
flutter pub add firebase_database
flutter run

Theo hướng dẫn
https://firebase.flutter.dev/docs/messaging/overview

Xem them:
https://pub.dev/packages/firebase_messaging/example

Chạy app, lấy FCM token
Vào FCM Dashboard(Engage -> messaging):
https://console.firebase.google.com/project/stockapp-b0883/messaging/onboarding
Gửi thử FCM, dùng FCM token ở trên

Tuỳ chỉnh cho ios:
Có thể tạo lại thư mục ios(nếu build bằng Xcode bị lỗi):
Xoá thư mục ios:
rm -rf ios
flutter create --ios-language swift .
flutter devices
flutter run -d d7865a14accdaca9abf76a68a73169a04dabeb20

Tuỳ chỉnh cho ios:
https://firebase.flutter.dev/docs/messaging/apple-integration
Key ID: 5HU22Y2HT7
Team ID: XX74TTBC92

File P8 là một loại tệp chứa khóa riêng tư dạng PEM được sử dụng bởi Apple
để cung cấp quyền truy cập tới một số dịch vụ, như chẳng hạn Apple Push Notification service (APNs).
File P8 cụ thể được sử dụng để tạo và xác thực mã thông báo (tokens) mà ứng dụng của bạn
sẽ sử dụng để kết nối với APNs.
* */
