import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum GroupPlan with LocalizedEnum {
  family(4),
  standard(20),
  professional(50),
  corporative(null);

  final int? maxUsers;
  const GroupPlan(this.maxUsers);

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
