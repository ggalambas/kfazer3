import 'package:flutter/material.dart';

class WorkspaceDetailsPage extends StatelessWidget {
  final VoidCallback onSuccess;
  const WorkspaceDetailsPage({super.key, required this.onSuccess});

  //TODO workspace setup > details page
  // gonna be something very similar with the account screen, so let's do that one first

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Workspace details'));
  }
}
