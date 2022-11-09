import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class DetailsBar extends StatelessWidget with PreferredSizeWidget {
  final bool loading;
  final String? title;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? deleteText;

  const DetailsBar({
    super.key,
    this.loading = false,
    this.title,
    required this.onEdit,
    required this.onDelete,
    this.deleteText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title == null ? null : Text(title!),
      actions: [
        IconButton(
          tooltip: context.loc.edit,
          onPressed: loading ? null : onEdit?.call,
          icon: const Icon(Icons.edit),
        ),
        SingleChildMenuButton(
          enabled: !loading,
          onSelected: onDelete,
          child: Text(
            deleteText ?? context.loc.delete,
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
