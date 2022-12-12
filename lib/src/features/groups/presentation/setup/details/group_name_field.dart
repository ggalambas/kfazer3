import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

class GroupNameField extends ConsumerWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onSubmit;
  final FormFieldValidator<String>? validator;

  const GroupNameField({
    super.key,
    this.focusNode,
    this.controller,
    this.onSubmit,
    this.validator,
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
      validator: validator,
    );
  }
}
