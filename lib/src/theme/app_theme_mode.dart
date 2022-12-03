import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum AppThemeMode with LocalizedEnum {
  system(ThemeMode.system),
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  final ThemeMode mode;
  const AppThemeMode(this.mode);

  @override
  String locName(BuildContext context) {
    switch (this) {
      case system:
        return context.loc.system;
      case light:
        return context.loc.light;
      case dark:
        return context.loc.dark;
    }
  }
}
