import 'package:flutter/material.dart';

class SingleChildPopupMenuButton extends StatelessWidget {
  final VoidCallback onSelected;
  final Widget child;

  const SingleChildPopupMenuButton({
    super.key,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (_) => onSelected(),
      itemBuilder: (_) => [PopupMenuItem(value: UniqueKey(), child: child)],
    );
  }
}
