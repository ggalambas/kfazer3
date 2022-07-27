import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

import 'shared_preferences_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);

abstract class SettingsRepository {
  Future<void> init();
  OpenOnStart getOpenOnStart();
  ThemeMode getThemeMode();
  Language getLanguage();
  WorkspaceId? getLastWorkspaceId();
  Stream<OpenOnStart> watchOpenOnStart();
  Stream<ThemeMode> watchThemeMode();
  Stream<Language> watchLanguage();
  void setOpenOnStart(OpenOnStart openOnStart);
  void setThemeMode(ThemeMode themeMode);
  void setLanguage(Language language);
  //TODO update this value when
  // opening a workspace
  // removing a workspace
  void setLastWorkspaceId(WorkspaceId? id);
}

//* Providers

final openOnStartStateProvider = StateNotifierProvider.autoDispose<
    SettingNotifier<OpenOnStart>, OpenOnStart>(
  (ref) => SettingNotifier(
    initial: ref.watch(settingsRepositoryProvider).getOpenOnStart(),
    stream: ref.watch(settingsRepositoryProvider).watchOpenOnStart(),
  ),
);

final themeModeStateProvider =
    StateNotifierProvider.autoDispose<SettingNotifier<ThemeMode>, ThemeMode>(
  (ref) => SettingNotifier(
    initial: ref.watch(settingsRepositoryProvider).getThemeMode(),
    stream: ref.watch(settingsRepositoryProvider).watchThemeMode(),
  ),
);

final languageStateProvider =
    StateNotifierProvider.autoDispose<SettingNotifier<Language>, Language>(
  (ref) => SettingNotifier(
    initial: ref.watch(settingsRepositoryProvider).getLanguage(),
    stream: ref.watch(settingsRepositoryProvider).watchLanguage(),
  ),
);

class SettingNotifier<T> extends StateNotifier<T> {
  SettingNotifier({
    required T initial,
    required Stream<T> stream,
  }) : super(initial) {
    _listen(stream);
  }

  void _listen(Stream<T> stream) {
    stream.listen((setting) => state = setting);
  }
}
