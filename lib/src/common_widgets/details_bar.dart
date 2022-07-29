import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class DetailsBar extends ConsumerWidget with PreferredSizeWidget {
  final bool loading;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? title;

  const DetailsBar({
    super.key,
    this.title,
    this.loading = false,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: title == null ? null : Text(title!),
      actions: [
        IconButton(
          tooltip: 'Edit'.hardcoded,
          onPressed: loading ? null : onEdit?.call,
          icon: const Icon(Icons.edit),
        ),
        SingleChildMenuButton(
          enabled: !loading,
          onSelected: onDelete,
          child: Text(
            'Delete'.hardcoded,
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EditingBar extends ConsumerWidget with PreferredSizeWidget {
  final bool loading;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final String? title;

  const EditingBar({
    super.key,
    this.title,
    this.loading = false,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        onPressed: loading ? null : onCancel,
        icon: const Icon(Icons.close),
      ),
      title: title == null ? null : Text(title!),
      actions: [
        LoadingTextButton(
          loading: loading,
          onPressed: onSave,
          child: Text('Save'.hardcoded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
