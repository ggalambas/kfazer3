import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/features/groups/presentation/setup/group_setup_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class InviteField extends ConsumerWidget {
  final FocusNode? focusNode;
  final TextEditingController phoneNumberController;
  final PhoneCodeController phoneCodeController;
  final Future<PhoneNumber> Function() pickFromContacts;
  final VoidCallback? onSubmit;

  const InviteField({
    super.key,
    this.focusNode,
    required this.phoneNumberController,
    required this.phoneCodeController,
    required this.pickFromContacts,
    this.onSubmit,
  });

  Future<void> _pickFromContacts() async {
    final phoneNumber = await pickFromContacts();
    if (phoneNumber.code.isNotEmpty) {
      phoneCodeController.code = phoneNumber.code;
    }
    phoneNumberController.text = phoneNumber.number;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      focusNode: focusNode,
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onEditingComplete: onSubmit,
      validator: (phoneNumber) => ref
          .read(groupSetupControllerProvider.notifier)
          .phoneNumberErrorText(context, phoneNumber ?? ''),
      decoration: InputDecoration(
        labelText: context.loc.phoneNumber,
        prefix: PhoneCodeDropdownPrefix(controller: phoneCodeController),
        suffixIcon: ValueListenableBuilder(
            valueListenable: phoneNumberController,
            builder: (context, _, __) {
              return phoneNumberController.text.isNotEmpty
                  ? TextButton(
                      onPressed: onSubmit,
                      child: Text('Add'.hardcoded),
                    )
                  : IconButton(
                      onPressed: _pickFromContacts,
                      icon: const Icon(Icons.perm_contact_calendar),
                    );
            }),
      ),
    );
  }
}
