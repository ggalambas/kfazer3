import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading_button.dart';

/// Generic function to show a Material dialog with a loading button
/// The dialog is not automatically dismissed after [onDefaultAction]
Future<void> showLoadingDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
  required AsyncCallback onDefaultAction,
}) =>
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => LoadingDialog(
        title: title,
        content: content,
        cancelActionText: cancelActionText,
        defaultActionText: defaultActionText,
        onDefaultAction: onDefaultAction,
      ),
    );

class LoadingDialog extends StatefulWidget {
  final String title;
  final String? content;
  final String? cancelActionText;
  final AsyncCallback onDefaultAction;
  final String defaultActionText;

  const LoadingDialog({
    super.key,
    required this.title,
    this.content,
    this.cancelActionText,
    required this.defaultActionText,
    required this.onDefaultAction,
  });

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: widget.content == null ? null : Text(widget.content!),
      actions: [
        if (widget.cancelActionText != null)
          TextButton(
            onPressed: isLoading ? null : Navigator.of(context).pop,
            child: Text(widget.cancelActionText!),
          ),
        LoadingTextButton(
          loading: isLoading,
          onPressed: () async {
            setState(() => isLoading = true);
            await widget.onDefaultAction();
            if (mounted) setState(() => isLoading = false);
          },
          child: Text(widget.defaultActionText),
        ),
      ],
    );
  }
}
