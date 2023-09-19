import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/settings/state.dart';
import 'package:myapp/screens/settings/index.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocBuilder<SettingCubit, SettingsState>(
        builder: (context, state) {
          final language = state.isVietnamese ? 'Tiếng Việt': 'Tiếng Anh';
          final mode = state.isDarkMode ? 'Chế độ tối':'Chế độ sáng';
          print('HomeScreen, language is: ${language}, mode is ${mode}');
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Sử dụng Navigator để điều hướng đến SettingsScreen
                  Navigator.pushNamed(context, '/settings');
                },
                child: Text('Navigate To Settings'),
              ),
              Text(
                mode,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Ngôn ngữ : ${language}',
                style: TextStyle(fontSize: 20),
              ),
              Text('appTitle'.tr()),
            ],
          );
        },
      ),
    );
  }
}

