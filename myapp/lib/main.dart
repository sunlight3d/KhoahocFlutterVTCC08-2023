import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/bloc.dart';
import 'package:myapp/screens/camera_scan/index.dart';
import 'package:myapp/screens/home/index.dart';
import 'package:myapp/screens/nfc_scanning_guide/index.dart';
import 'package:myapp/screens/profile/index.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/services/index.dart';


GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => UserService());//like AddServices in .net core mvc
  locator.registerLazySingleton(() => ProductService());
}

/*
Detail user: https://randomuser.me/api/

* */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Đảm bảo gọi hàm setupLocator trước runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: NFCScanningGuide(),
      //home: CameraScan()
      //home: Profile()
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(),
          ),
        ],
        child: HomeScreen(),
      )
    );
  }
}

