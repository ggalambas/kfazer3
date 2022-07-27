import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  late final SharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  T getSetting<T extends Enum>(List<T> values) =>
      values[prefs.getInt(values.first.runtimeType.toString()) ?? 0];
  @override
  void setSetting<T extends Enum>(T value) =>
      prefs.setInt(value.runtimeType.toString(), value.index);
}
