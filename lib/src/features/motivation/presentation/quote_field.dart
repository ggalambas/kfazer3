import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:smart_space/smart_space.dart';

class QuoteDisplayField extends StatelessWidget {
  final String quote;
  const QuoteDisplayField(this.quote, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      initialValue: quote,
      maxLines: null,
      decoration: InputDecoration(
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.all(kSpace),
      ),
    );
  }
}

class QuoteField extends ConsumerWidget {
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onDelete;
  final FormFieldValidator<String>? validator;

  const QuoteField({
    super.key,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.onDelete,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLength: kQuoteLength,
      maxLines: null,
      decoration: InputDecoration(
        counterText: '',
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.all(kSpace),
        suffixIcon: IconButton(
          tooltip: context.loc.delete,
          onPressed: enabled ? onDelete : null,
          icon: const Icon(Icons.clear),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
