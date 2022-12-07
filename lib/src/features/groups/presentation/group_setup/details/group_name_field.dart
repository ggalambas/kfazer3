import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

class GroupNameField extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool submitted;

  const GroupNameField({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.onSubmit,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      maxLength: kNameLength,
      decoration: InputDecoration(
        counterText: '',
        labelText: context.loc.name,
      ),
      onEditingComplete: onSubmit,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (name) {
        if (!submitted) return null;
        return ref
            .read(groupSetupControllerProvider.notifier)
            .nameErrorText(context, name ?? '');
      },
    );
  }
}
