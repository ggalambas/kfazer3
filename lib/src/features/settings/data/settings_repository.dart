import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/localization/language.dart';
import 'package:kfazer3/src/theme/loc_theme_mode.dart';
import 'package:kfazer3/src/utils/stream_notifier.dart';

import 'shared_preferences_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);

abstract class SettingsRepository {
  Future<void> init();
  LocThemeMode getThemeMode();
  Language getLanguage();
  Stream<LocThemeMode> watchThemeMode();
  Stream<Language> watchLanguage();
  void setThemeMode(LocThemeMode themeMode);
  void setLanguage(Language language);
}

//* Providers

final themeModeStateProvider = StateNotifierProvider.autoDispose<
    StreamNotifier<LocThemeMode>, LocThemeMode>(
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
