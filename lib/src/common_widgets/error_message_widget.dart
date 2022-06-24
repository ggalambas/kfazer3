import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  const ErrorMessageWidget(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      errorMessage,
      style: theme.textTheme.titleLarge!.copyWith(color: theme.errorColor),
    );
  }
}
