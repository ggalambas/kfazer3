import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/members/domain/member_role.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';

enum MemberMenuOption with LocalizedEnum {
  transferOwnership(
    editors: [MemberRole.owner],
    targets: [MemberRole.admin, MemberRole.member],
  ),
  makeAdmin(
    editors: [MemberRole.owner, MemberRole.admin],
    targets: [MemberRole.member],
  ),
  removeAdmin(
    editors: [MemberRole.owner, MemberRole.admin],
    targets: [MemberRole.admin],
  ),
  removeMember(
    editors: [MemberRole.owner, MemberRole.admin],
    targets: [MemberRole.admin, MemberRole.member],
  ),
  removeInvite(
    editors: [MemberRole.owner, MemberRole.admin],
    targets: [MemberRole.pending],
  );

  final List<MemberRole> editors;
  final List<MemberRole> targets;
  const MemberMenuOption({required this.editors, required this.targets});

  static List<MemberMenuOption> allowedValues(
    MemberRole editor,
    MemberRole target,
  ) =>
      values
          .where((option) =>
              option.editors.contains(editor) &&
              option.targets.contains(target))
          .toList();

  @override
  String locName(BuildContext context) {
    switch (this) {
      case transferOwnership:
        return context.loc.transferOwnership;
      case makeAdmin:
        return context.loc.makeAdmin;
      case removeAdmin:
        return context.loc.removeAsAdmin;
      case removeMember:
        return context.loc.removeFromGroup;
      case removeInvite:
        return context.loc.removeInvite;
    }
  }
}
