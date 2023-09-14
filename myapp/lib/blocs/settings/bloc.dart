// 3. Tạo Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/event.dart';
import 'package:myapp/blocs/settings/state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /*
  SettingsBloc() : super(SettingsState(isDarkMode: false, isVietnamese: false));
*/
  SettingsBloc() : super(SettingsState(isDarkMode: false, isVietnamese: false)) {
    on<SettingsEvent>((event, emit) async* {
      if (event is ToggleDarkModeEvent) {
        // Xử lý ToggleDarkModeEvent ở đây và trả về trạng thái mới
        yield SettingsState(
        isDarkMode: !state.isDarkMode,
        isVietnamese: state.isVietnamese,
        );
      } else if (event is LanguageChangedEvent) {
        // Xử lý ToggleLanguageEvent ở đây và trả về trạng thái mới
        yield SettingsState(
        isDarkMode: state.isDarkMode,
        isVietnamese: !state.isVietnamese,
        );
      }
    });
  }

  // @override
  // Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
  //   if (event is ToggleDarkModeEvent) {
  //     // Xử lý ToggleDarkModeEvent ở đây và trả về trạng thái mới
  //     yield SettingsState(
  //       isDarkMode: !state.isDarkMode,
  //       isVietnamese: state.isVietnamese,
  //     );
  //   } else if (event is LanguageChangedEvent) {
  //     // Xử lý ToggleLanguageEvent ở đây và trả về trạng thái mới
  //     yield SettingsState(
  //       isDarkMode: state.isDarkMode,
  //       isVietnamese: !state.isVietnamese,
  //     );
  //   }
  // }
}

