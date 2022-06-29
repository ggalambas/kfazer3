import 'package:flutter/material.dart';

class TapToUnfocus extends StatelessWidget {
  final Widget child;
  const TapToUnfocus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
