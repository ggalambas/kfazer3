import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/localization/language.dart';
import 'package:kfazer3/src/theme/app_theme_mode.dart';
import 'package:kfazer3/src/utils/stream_notifier.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);

abstract class SettingsRepository {
  AppThemeMode getThemeMode();
  Language getLanguage();
  Stream<AppThemeMode> watchThemeMode();
  Stream<Language> watchLanguage();
  void setThemeMode(AppThemeMode themeMode);
  void setLanguage(Language language);
}

//* Providers

final themeModeStateProvider = StateNotifierProvider.autoDispose<
    StreamNotifier<AppThemeMode>, AppThemeMode>(
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
