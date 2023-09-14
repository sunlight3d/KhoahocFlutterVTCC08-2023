// 1. Tạo sự kiện (events)
abstract class SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDarkMode;
  ToggleDarkModeEvent(this.isDarkMode);
  @override
  String toString() => 'ToggleDarkModeEvent: isDarkMode=$isDarkMode';
}

class LanguageChangedEvent extends SettingsEvent {
  final bool isVietnamese;
  LanguageChangedEvent(this.isVietnamese);
  @override
  String toString() => 'LanguageChangedEvent: isVietnamese=$isVietnamese';
}
