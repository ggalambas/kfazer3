import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/utils/stream_notifier.dart';

import 'shared_preferences_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);

abstract class SettingsRepository {
  Future<void> init();
  ThemeMode getThemeMode();
  Language getLanguage();
  Stream<ThemeMode> watchThemeMode();
  Stream<Language> watchLanguage();
  void setThemeMode(ThemeMode themeMode);
  void setLanguage(Language language);
}

//* Providers

final themeModeStateProvider =
    StateNotifierProvider.autoDispose<StreamNotifier<ThemeMode>, ThemeMode>(
  (ref) {
    final repository = ref.watch(settingsRepositoryProvider);
    return StreamNotifier(
      initial: repository.getThemeMode(),
      stream: repository.watchThemeMode(),
    );
  },
);

final languageStateProvider =
    StateNotifierProvider.autoDispose<StreamNotifier<Language>, Language>(
  (ref) {
    final repository = ref.watch(settingsRepositoryProvider);
    return StreamNotifier(
      initial: repository.getLanguage(),
      stream: repository.watchLanguage(),
    );
  },
);
