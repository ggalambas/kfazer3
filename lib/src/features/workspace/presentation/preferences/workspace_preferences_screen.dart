import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class WorkspacePreferencesScreen extends StatelessWidget {
  const WorkspacePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preferences'.hardcoded)),
      body: Center(child: Text('Preferences'.hardcoded)),
    );
  }
}
