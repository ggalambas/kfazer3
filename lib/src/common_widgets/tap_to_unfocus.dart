import 'package:flutter/material.dart';

extension ContextUnfocus on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();
}

class TapToUnfocus extends StatelessWidget {
  final Widget child;
  const TapToUnfocus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.unfocus,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
