import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/empty_placeholder.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  const ErrorMessageWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyPlaceholder(
      illustration: UnDrawIllustration.notify,
      illustrationColor: context.colorScheme.error,
      message: message,
    );
  }
}
