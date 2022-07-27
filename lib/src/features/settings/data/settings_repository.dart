import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);

abstract class SettingsRepository {
  Future<void> init();
  T getSetting<T extends Enum>(List<T> values);
  void setSetting<T extends Enum>(T value);
}
