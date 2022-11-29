import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

enum ButtonType { fab, elevated }

class CreateGroupButton extends StatelessWidget {
  final ButtonType type;
  const CreateGroupButton.fab({super.key}) : type = ButtonType.fab;
  const CreateGroupButton.elevated({super.key}) : type = ButtonType.elevated;

  void onPressed(BuildContext context) =>
      context.goNamed(AppRoute.workspaceSetup.name);

  final icon = const Icon(Icons.add);

  Widget label(BuildContext context) => Text(context.loc.createNew);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.fab:
        return FloatingActionButton.extended(
          onPressed: () => onPressed(context),
          icon: icon,
          label: label(context),
        );
      case ButtonType.elevated:
        return ElevatedButton.icon(
          onPressed: () => onPressed(context),
          icon: icon,
          label: label(context),
        );
    }
  }
}
