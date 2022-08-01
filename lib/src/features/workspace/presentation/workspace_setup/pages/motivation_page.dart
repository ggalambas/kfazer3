import 'package:flutter/material.dart';

class MotivationalMessagesPage extends StatelessWidget {
  final VoidCallback onSuccess;
  const MotivationalMessagesPage({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Motivational messages'));
  }
}
