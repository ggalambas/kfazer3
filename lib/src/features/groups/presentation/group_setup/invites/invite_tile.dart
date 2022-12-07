import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:smart_space/smart_space.dart';

//TODO show contact name
class InviteTile extends StatelessWidget {
  final PhoneNumber phoneNumber;
  final void Function(PhoneNumber phoneNumber) onRemove;

  const InviteTile(
    this.phoneNumber, {
    super.key,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: kSpace * 2),
      title: Text(phoneNumber.toString()),
      trailing: IconButton(
        tooltip: context.loc.delete, //!
        iconSize: kSmallIconSize,
        onPressed: () => onRemove(phoneNumber),
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
