import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';

import 'shared_preferences_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);

abstract class SettingsRepository {
  Future<void> init();
  T getSetting<T extends Enum>(List<T> values);
  void setSetting<T extends Enum>(T value);
}

//* Providers

final openOnStartStateProvider = StateNotifierProvider.autoDispose<
    SettingNotifier<OpenOnStart>, OpenOnStart>((ref) {
  final initial =
      ref.watch(settingsRepositoryProvider).getSetting(OpenOnStart.values);
  return SettingNotifier(ref.read, initial);
});

final themeModeStateProvider =
    StateNotifierProvider.autoDispose<SettingNotifier<ThemeMode>, ThemeMode>(
        (ref) {
  final initial =
      ref.watch(settingsRepositoryProvider).getSetting(ThemeMode.values);
  return SettingNotifier(ref.read, initial);
});

final languageStateProvider =
    StateNotifierProvider.autoDispose<SettingNotifier<Language>, Language>(
        (ref) {
  final initial =
      ref.watch(settingsRepositoryProvider).getSetting(Language.values);
  return SettingNotifier(ref.read, initial);
});

class SettingNotifier<T extends Enum> extends StateNotifier<T> {
  final Reader read;
  SettingNotifier(this.read, T value) : super(value);

  @override
  set state(T value) {
    read(settingsRepositoryProvider).setSetting(value);
    super.state = value;
  }
}
