import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/content_dialog.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class CreateWorkspaceFab extends StatefulWidget {
  const CreateWorkspaceFab({super.key});

  @override
  State<CreateWorkspaceFab> createState() => _CreateWorkspaceFabState();
}

class _CreateWorkspaceFabState extends State<CreateWorkspaceFab> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final saved = await showContentDialog(
          context: context,
          title: 'New workspace'.hardcoded,
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Title'.hardcoded),
            onEditingComplete: () => Navigator.of(context).pop(true),
          ),
          defaultActionText: 'Save',
        );
        if (saved == true) {
          showNotImplementedAlertDialog(context: context);
        }
        textController.clear(); //! weird
      },
      icon: const Icon(Icons.add),
      label: Text('Create new'.hardcoded),
    );
  }
}
