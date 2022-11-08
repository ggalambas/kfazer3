import 'package:flutter/material.dart';

class SingleChildMenuButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onSelected;
  final Widget child;

  const SingleChildMenuButton({
    super.key,
    this.enabled = true,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enabled: enabled,
      onSelected: (_) => onSelected?.call(),
      //? why the unique key?
      itemBuilder: (_) => [PopupMenuItem(value: UniqueKey(), child: child)],
    );
  }
}
