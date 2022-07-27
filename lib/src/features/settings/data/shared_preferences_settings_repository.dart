import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
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
  OpenOnStart getOpenOnStart() {
    final i = prefs.getInt(openOnStartKey, defaultValue: 0).getValue();
    return OpenOnStart.values[i];
  }

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
  Stream<OpenOnStart> watchOpenOnStart() => prefs
      .getInt(openOnStartKey, defaultValue: 0)
      .map((i) => OpenOnStart.values[i]);

  @override
  Stream<ThemeMode> watchThemeMode() => prefs
      .getInt(themeModeKey, defaultValue: 0)
      .map((i) => ThemeMode.values[i]);

  @override
  Stream<Language> watchLanguage() =>
      prefs.getInt(languageKey, defaultValue: 0).map((i) => Language.values[i]);

  @override
  void setOpenOnStart(OpenOnStart openOnStart) =>
      prefs.setInt(openOnStartKey, openOnStart.index);

  @override
  void setThemeMode(ThemeMode themeMode) =>
      prefs.setInt(themeModeKey, themeMode.index);

  @override
  void setLanguage(Language language) =>
      prefs.setInt(languageKey, language.index);

  @override
  WorkspaceId? getLastWorkspaceId() {
    final id = prefs.getString(lastWorkspaceKey, defaultValue: '').getValue();
    return id.isEmpty ? null : id;
  }

  @override
  void setLastWorkspaceId(WorkspaceId? id) => id == null
      ? prefs.remove(lastWorkspaceKey)
      : prefs.setString(lastWorkspaceKey, id);
}
