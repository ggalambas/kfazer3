import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';

class CircularProgressIcon extends StatelessWidget {
  const CircularProgressIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: kSmallIconSize,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
