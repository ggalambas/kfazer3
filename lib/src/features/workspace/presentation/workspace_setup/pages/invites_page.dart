import 'package:flutter/material.dart';

class InvitesPage extends StatelessWidget {
  final void Function(String workspaceId) onSuccess;
  const InvitesPage({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Invites'));
  }
}
