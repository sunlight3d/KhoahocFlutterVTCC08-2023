import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/settings/state.dart';
import 'package:myapp/blocs/tasks/cubit.dart';
import 'package:myapp/blocs/tasks/state.dart';
import 'package:myapp/databases/sqlite_db_helper.dart';
import 'package:myapp/models/location.dart';
import 'package:myapp/models/task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_sqliteDBHelper.getTasks();
    //StreamController<List<Task>> _tasksController = StreamController<List<Task>>.broadcast();
    //_sqliteDBHelper.tasksStream = _tasksController.stream;
    //_sqliteDBHelper.clear();
    final MethodChannel platform = MethodChannel('channel_01');
    platform.invokeMethod('your_native_method_name').then((value) {
      print('haha');
    });
  }
  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('vi', 'VN'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocBuilder<SettingCubit, SettingsState>(
        builder: (context, state) {
          final language = state.isVietnamese ? 'Tiếng Việt': 'Tiếng Anh';
          final mode = state.isDarkMode ? 'Chế độ tối':'Chế độ sáng';
          print('HomeScreen, language is: ${language}, mode is ${mode}');
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
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
                Text('appTitle').tr(),
                Text('welcomeMessage'.tr(args: ['John'])),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tên Công Việc'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _showDateTimePicker(context);
                  },
                  child: Text('Chọn Thời Gian Bắt Đầu'),
                ),
                SizedBox(height: 16.0),
                Text('Thời Gian Bắt Đầu: ${_selectedDateTime.toString()}'),
                SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(
                        context, '/location',
                        arguments: ({
                          required double lat,
                          required double lon,
                          required String address}){
                          print('haha');
                        },);
                    },
                    child: Text('Select Location')
                ),
                ElevatedButton(
                  onPressed: () {
                    final String name = _nameController.text;
                    final String startTime = _selectedDateTime.toLocal().toString();
                    final Task task = Task(name: name, startTime: startTime);
                    context.read<TaskCubit>().insertTask(task);
                  },
                  child: Text('Lưu'),
                ),

                Expanded(
                  child: BlocBuilder<TaskCubit, TasksState>(
                    builder: (context, state) {
                      return ListView.  builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.tasks[index].name),
                          );
                        },
                      );
                    },
                  ),
                ),
                Text('Footer')
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    ).then((selectedDate) {
      if (selectedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate),
        ).then((selectedTime) {
          if (selectedTime != null) {
            // Bạn có thể sử dụng selectedDate và selectedTime ở đây
            DateTime selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            setState(() {
              _selectedDateTime = selectedDateTime;
            });
          }
        });
      }
    });
  }
}

