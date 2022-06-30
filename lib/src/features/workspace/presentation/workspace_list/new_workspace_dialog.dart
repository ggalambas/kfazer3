import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class NewWorkspaceDialog extends StatefulWidget {
  const NewWorkspaceDialog({super.key});

  @override
  State<NewWorkspaceDialog> createState() => _NewWorkspaceDialogState();
}

class _NewWorkspaceDialogState extends State<NewWorkspaceDialog> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> create() => showNotImplementedAlertDialog(context: context);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New workspace'.hardcoded),
      content: TextField(
        controller: textController,
        decoration: InputDecoration(hintText: 'Title'.hardcoded),
        onEditingComplete: () async {
          await create();
          Navigator.of(context).pop();
        },
      ),
      actions: [
        TextButton(
          child: const Text('Save'),
          onPressed: () async {
            await create();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
