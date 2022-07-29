import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/domain/settings.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/utils/stream_notifier.dart';

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
  // removing a workspace
  void setLastWorkspaceId(WorkspaceId id);
  void removeLastWorkspaceId();
}

//* Providers

final openOnStartStateProvider =
    StateNotifierProvider.autoDispose<StreamNotifier<OpenOnStart>, OpenOnStart>(
  (ref) {
    final repository = ref.watch(settingsRepositoryProvider);
    return StreamNotifier(
      initial: repository.getOpenOnStart(),
      stream: repository.watchOpenOnStart(),
    );
  },
);

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
