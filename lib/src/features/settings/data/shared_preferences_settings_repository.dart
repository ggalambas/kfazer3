import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  late final StreamingSharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await StreamingSharedPreferences.instance;
  }

  final openOnStartKey = 'openOnStart';
  final themeModeKey = 'themeMode';
  final languageKey = 'language';
  final lastWorkspaceKey = 'lastWorkspaceKey';

  @override
  ThemeMode getThemeMode() {
    final i = prefs.getInt(themeModeKey, defaultValue: 0).getValue();
    return ThemeMode.values[i];
  }

  @override
  Language getLanguage() {
    final i = prefs.getInt(languageKey, defaultValue: 0).getValue();
    return Language.values[i];
  }

  @override
  Stream<ThemeMode> watchThemeMode() => prefs
      .getInt(themeModeKey, defaultValue: 0)
      .map((i) => ThemeMode.values[i]);

  @override
  Stream<Language> watchLanguage() =>
      prefs.getInt(languageKey, defaultValue: 0).map((i) => Language.values[i]);

  @override
  void setThemeMode(ThemeMode themeMode) =>
      prefs.setInt(themeModeKey, themeMode.index);

  @override
  void setLanguage(Language language) =>
      prefs.setInt(languageKey, language.index);
}
