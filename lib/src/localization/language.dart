import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum Language with LocalizedEnum {
  system(null),
  english(Locale('en')),
  portuguese(Locale('pt')),
  spanish(Locale('es'));

  final Locale? locale;
  const Language(this.locale);

  @override
  String locName(BuildContext context) {
    switch (this) {
      case system:
        return context.loc.system;
      case english:
        return context.loc.english;
      case portuguese:
        return context.loc.portuguese;
      case spanish:
        return context.loc.spanish;
    }
  }
}
