import 'package:flutter/material.dart';

class SingleItemPopupMenuButton extends StatelessWidget {
  final VoidCallback onSelected;
  final Widget item;

  const SingleItemPopupMenuButton({
    super.key,
    required this.onSelected,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (_) => onSelected(),
      itemBuilder: (_) => [PopupMenuItem(value: UniqueKey(), child: item)],
    );
  }
}
