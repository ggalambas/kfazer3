import 'package:flutter/widgets.dart';

enum Language {
  system(null),
  english(Locale('en')),
  portuguese(Locale('pt')),
  spanish(Locale('es'));

  final Locale? locale;
  const Language(this.locale);
}
