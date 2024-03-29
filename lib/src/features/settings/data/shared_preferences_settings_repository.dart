import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/language.dart';
import 'package:kfazer3/src/theme/app_theme_mode.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

// TODO test shared preferences with mock values
class SharedPreferencesSettingsRepository implements SettingsRepository {
  final StreamingSharedPreferences prefs;
  SharedPreferencesSettingsRepository(this.prefs);

  static Future<SharedPreferencesSettingsRepository> get instance async {
    final prefs = await StreamingSharedPreferences.instance;
    return SharedPreferencesSettingsRepository(prefs);
  }

  final openOnStartKey = 'openOnStart';
  final themeModeKey = 'themeMode';
  final languageKey = 'language';

  @override
  AppThemeMode getThemeMode() {
    final i = prefs.getInt(themeModeKey, defaultValue: 0).getValue();
    return AppThemeMode.values[i];
  }

  @override
  Language getLanguage() {
    final i = prefs.getInt(languageKey, defaultValue: 0).getValue();
    return Language.values[i];
  }

  @override
  Stream<AppThemeMode> watchThemeMode() => prefs
      .getInt(themeModeKey, defaultValue: 0)
      .map((i) => AppThemeMode.values[i]);

  @override
  Stream<Language> watchLanguage() =>
      prefs.getInt(languageKey, defaultValue: 0).map((i) => Language.values[i]);

  @override
  void setThemeMode(AppThemeMode themeMode) =>
      prefs.setInt(themeModeKey, themeMode.index);

  @override
  void setLanguage(Language language) =>
      prefs.setInt(languageKey, language.index);
}
