import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

//TODO use empty widget
class ErrorMessageWidget extends StatelessWidget {
  final String errorMessage;
  const ErrorMessageWidget(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: context.textTheme.titleLarge!.copyWith(
        color: context.theme.errorColor,
      ),
    );
  }
}
