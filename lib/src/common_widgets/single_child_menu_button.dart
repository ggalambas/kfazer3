import 'package:flutter/material.dart';

class SingleChildMenuButton extends StatelessWidget {
  final VoidCallback? onSelected;
  final Widget child;

  const SingleChildMenuButton({
    super.key,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: onSelected != null,
      onSelected: (_) => onSelected?.call(),
      itemBuilder: (_) => [PopupMenuItem(value: UniqueKey(), child: child)],
    );
  }
}
