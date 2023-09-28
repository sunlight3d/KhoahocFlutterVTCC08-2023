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
  // Reload changes from the database
  Future<void> _reloadChanges() async {
    final tasks = await _sqliteDBHelper.getTasks();
    emit(TasksState(tasks: tasks));
  }

// Insert a task into the database
  Future<void> insertTask(Task task) async {
    await _sqliteDBHelper.insertTask(task);
    await _reloadChanges();
  }

// Get all tasks from the database
  Future<void> getTasks() async {
    await _reloadChanges();
  }

// Delete a task from the database by its ID
  Future<void> deleteTask(int id) async {
    await _sqliteDBHelper.deleteTask(id);
    await _reloadChanges();
  }
}
