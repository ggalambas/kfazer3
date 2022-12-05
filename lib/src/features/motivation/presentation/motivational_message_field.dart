import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_edit_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_validators.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:smart_space/smart_space.dart';

class MotivationalMessageDisplayField extends StatelessWidget {
  final String message;
  const MotivationalMessageDisplayField(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: message,
      maxLines: null,
      decoration: InputDecoration(
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.all(kSpace),
      ),
    );
  }
}

class MotivationalMessageField extends ConsumerWidget {
  final bool submitted;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onDelete;

  const MotivationalMessageField({
    super.key,
    required this.submitted,
    required this.controller,
    this.focusNode,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: kMotivationalMessagesLength,
      maxLines: null,
      decoration: InputDecoration(
        counterText: '',
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.all(kSpace),
        suffixIcon: IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: context.loc.delete,
          // iconSize: kSmallIconSize, //!
          onPressed: onDelete,
          icon: const Icon(Icons.clear),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (message) {
        if (!submitted) return null;
        return ref
            .read(motivationEditControllerProvider.notifier)
            .messageErrorText(context, message ?? '');
      },
    );
  }
}
