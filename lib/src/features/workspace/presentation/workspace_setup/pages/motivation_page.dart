import 'package:flutter/material.dart';

class MotivationalMessagesPage extends StatelessWidget {
  final VoidCallback onSuccess;
  const MotivationalMessagesPage({super.key, required this.onSuccess});

  //TODO workspace setup > motivation page
  // it's gonna be the same as the motivationalMessagesScreen but with an explanation text

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Motivational messages'));
  }
}
