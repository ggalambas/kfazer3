import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.hardcoded),
        actions: [
          IconButton(
            onPressed: () => showNotImplementedAlertDialog(context: context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(child: Text('Notifications'.hardcoded)),
    );
  }
}
