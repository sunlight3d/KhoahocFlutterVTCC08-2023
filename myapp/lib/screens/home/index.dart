import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/cubit.dart';
import 'package:myapp/blocs/settings/state.dart';
import 'package:myapp/databases/database_helper.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/screens/settings/index.dart';
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
                onPressed: () {
                  _saveTask(context);
                },
                child: Text('Lưu'),
              ),
            ],
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

  void _saveTask(BuildContext context) {
    final String name = _nameController.text;
    final String startTime = _selectedDateTime.toLocal().toString();
    final DatabaseHelper dbHelper = DatabaseHelper();

    final Task task = Task(name: name, startTime: startTime);

    dbHelper.insertTask(task).then((_) {
      Navigator.of(context).pop();
    });
  }

}

