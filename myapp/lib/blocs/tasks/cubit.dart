import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/blocs/settings/state.dart';
import 'package:myapp/blocs/tasks/state.dart';
import 'package:myapp/databases/sqlite_db_helper.dart';
import 'package:myapp/models/task.dart';

class TaskCubit extends Cubit<TasksState> {
  final _sqliteDBHelper = GetIt.instance<SQLiteDBHelper>();
  TaskCubit() : super(TasksState(tasks: <Task>[]));
  void _reloadChanges() async {
    _sqliteDBHelper.getTasks().then((tasks) {
      emit(TasksState(tasks: tasks));
    });
  }
  void insertTask(Task task) {
    _sqliteDBHelper.insertTask(task).then((value) {
      _reloadChanges();
    });

  }
  void getTasks() {
    _reloadChanges();
  }
  void deleteTask(int id) {
    _sqliteDBHelper.deleteTask(id).then((value) {
      _reloadChanges();
    });
  }

}
