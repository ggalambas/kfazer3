import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/language.dart';
import 'package:kfazer3/src/theme/app_theme_mode.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

class FakeSettingsRepository implements SettingsRepository {
  final _themeMode = InMemoryStore<AppThemeMode>(AppThemeMode.system);
  final _language = InMemoryStore<Language>(Language.english);

  @override
  AppThemeMode getThemeMode() => _themeMode.value;

  @override
  Language getLanguage() => _language.value;

  @override
  Stream<AppThemeMode> watchThemeMode() => _themeMode.stream;

  @override
  Stream<Language> watchLanguage() => _language.stream;

  @override
  void setThemeMode(AppThemeMode themeMode) => _themeMode.value = themeMode;

  @override
  void setLanguage(Language language) => _language.value = language;
}
