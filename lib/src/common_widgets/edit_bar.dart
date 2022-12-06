import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/rail.dart';
import 'package:kfazer3/src/localization/localized_context.dart';

import 'loading_button.dart';

/// Custom [AppBar] widget that shows the following actions:
/// - Save button
class EditBar extends StatelessWidget with PreferredSizeWidget {
  final bool loading;
  final String? title;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final Widget? menuButton;

  const EditBar({
    super.key,
    this.loading = false,
    this.title,
    required this.onSave,
    required this.onCancel,
    this.menuButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CloseButton(onPressed: loading ? null : onCancel),
      title: title == null ? null : Text(title!),
      actions: [
        LoadingTextButton(
          loading: loading,
          onPressed: onSave,
          child: Text(context.loc.save),
        ),
        if (menuButton != null) menuButton!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom [Rail] widget that shows the following actions:
/// - Save button
class EditRail extends StatelessWidget {
  final bool loading;
  final String? title;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final List<Widget> actions;

  const EditRail({
    super.key,
    this.loading = false,
    this.title,
    required this.onSave,
    required this.onCancel,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Rail(
      leading: CloseButton(onPressed: loading ? null : onCancel),
      title: title,
      actions: [
        LoadingTextButton(
          loading: loading,
          onPressed: onSave,
          child: Text(context.loc.save),
        ),
        ...actions,
      ],
    );
  }
}
