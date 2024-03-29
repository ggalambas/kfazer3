import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// * run flutter gen-l10n
extension LocalizedContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  Locale get locale => Localizations.localeOf(this);
}
