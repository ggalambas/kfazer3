import 'package:flutter/material.dart';

class WorkspaceDetailsPage extends StatelessWidget {
  final VoidCallback onSuccess;
  const WorkspaceDetailsPage({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Workspace details'));
  }
}
