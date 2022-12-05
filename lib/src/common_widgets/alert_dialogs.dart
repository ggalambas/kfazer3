import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localization_context.dart';

// * keys for testing using find.byKey()
const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a Material dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String? defaultActionText,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          if (cancelActionText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionText),
            ),
          TextButton(
            key: kDialogDefaultKey,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText ?? context.loc.ok),
          ),
        ],
      ),
    );

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
    );

Future<void> showNotImplementedAlertDialog({required BuildContext context}) =>
    showAlertDialog(
      context: context,
      title: context.loc.notImplemented,
    );
