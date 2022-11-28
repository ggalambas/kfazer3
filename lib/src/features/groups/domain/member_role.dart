import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum MemberRole with LocalizedEnum {
  owner,
  admin,
  member,
  pending;

  bool get isOwner => this == owner;
  bool get isAdmin => this == admin;
  bool get isMember => this == member;
  bool get isPending => this == pending;

  @override
  String locName(BuildContext context) {
    switch (this) {
      case owner:
        return context.loc.owner;
      case admin:
        return context.loc.admin;
      case member:
        return context.loc.member;
      case pending:
        return context.loc.pending;
    }
  }
}
