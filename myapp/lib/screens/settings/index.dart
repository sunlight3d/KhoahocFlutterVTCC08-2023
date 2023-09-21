import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/settings/state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocBuilder<SettingCubit, SettingsState>(
        builder: (context, state) {
          print('SettignScreen, language is: ${state.isVietnamese}, mode is ${state.isDarkMode}');
          return Column(
            children: [
              SwitchListTile(
                title: Text('Enable Dark Mode'),
                value: state.isDarkMode,
                onChanged: (_) {
                  //dispatch an action
                  context.read<SettingCubit>().changeSettings(!state.isDarkMode, state.isVietnamese);

                },
              ),

              RadioListTile<bool>(
                title: Text('English'),
                value: false, // Đặt giá trị cho trạng thái English
                groupValue: state.isVietnamese, // Đối chiếu với trạng thái Vietnamese
                onChanged: (value) {
                  context.read<SettingCubit>().changeSettings(state.isDarkMode, false);
                },
              ),
              RadioListTile<bool>(
                title: Text('Vietnamese'),
                value: true, // Đặt giá trị cho trạng thái Vietnamese
                groupValue: state.isVietnamese, // Đối chiếu với trạng thái Vietnamese
                onChanged: (value) {
                  context.read<SettingCubit>().changeSettings(state.isDarkMode, true);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
