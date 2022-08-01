import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum WorkspacePlan with LocalizedEnum {
  family,
  standard,
  professional,
  corporative;

  @override
  String locName(BuildContext context) {
    switch (this) {
      case family:
        return context.loc.family;
      case standard:
        return context.loc.standard;
      case professional:
        return context.loc.professional;
      case corporative:
        return context.loc.corporative;
    }
  }
}
