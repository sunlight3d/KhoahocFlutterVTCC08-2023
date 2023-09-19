import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/state.dart';

class SettingCubit extends Cubit<SettingsState> {
  //initial state
  SettingCubit() : super(SettingsState(isDarkMode: false, isVietnamese: false));
  void changeSettings(bool _isDarkMode, bool _isVietnamese) {
    //dispatch an event
    SettingsState newState = SettingsState(
        isDarkMode: _isDarkMode,
        isVietnamese: _isVietnamese
    );
    emit(newState);
  }
}