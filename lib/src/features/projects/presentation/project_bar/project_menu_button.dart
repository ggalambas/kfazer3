import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';
import 'package:kfazer3/src/features/projects/presentation/project_screen_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

enum ProjectMenuOption with LocalizedEnum {
  about,
  preferences,
  members,
  archive,
  export,
  leave;

  @override
  String locName(BuildContext context) {
    switch (this) {
      case about:
        return context.loc.about;
      case preferences:
        return context.loc.preferences;
      case members:
        return context.loc.members;
      case archive:
        return context.loc.archive;
      case export:
        return context.loc.export;
      case leave:
        return context.loc.leave;
    }
  }
}

class ProjectMenuButton extends ConsumerStatefulWidget {
  final Project project;
  const ProjectMenuButton({super.key, required this.project});

  @override
  ConsumerState<ProjectMenuButton> createState() => ProjectMenuButtonState();
}

class ProjectMenuButtonState extends ConsumerState<ProjectMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (final option in ProjectMenuOption.values)
          PopupMenuItem(
            value: option,
            child: Text(
              option.locName(context),
              style: option == ProjectMenuOption.leave
                  ? TextStyle(color: context.colorScheme.error)
                  : null,
            ),
          ),
      ],
      onSelected: (option) {
        switch (option) {
          case ProjectMenuOption.about:
            showAlertDialog(
              context: context,
              title: widget.project.title,
              content: widget.project.description,
            );
            break;
          //TODO only show for admins
          // case ProjectMenuOption.preferences:
          //   context.pushNamed(
          //     AppRoute.projectPreferences.name,
          //     params: {'groupId': widget.project.id},
          //   );
          //   break;
          case ProjectMenuOption.members:
            //TODO go to members screen
            showNotImplementedAlertDialog(context: context);
            break;
          case ProjectMenuOption.archive:
            context.pushNamed(
              AppRoute.projectArchive.name,
              params: {'groupId': widget.project.id},
            );
            break;
          case ProjectMenuOption.export:
            //TODO export project
            showNotImplementedAlertDialog(context: context);
            break;
          case ProjectMenuOption.leave:
            //TODO don't show for creator
            showLoadingDialog(
              context: context,
              title: context.loc.areYouSure,
              cancelActionText: context.loc.cancel,
              defaultActionText: context.loc.leave,
              onDefaultAction: () async {
                final success = await ref
                    .read(projectScreenControllerProvider.notifier)
                    .leaveProject(widget.project);
                if (mounted && success) context.goNamed(AppRoute.home.name);
              },
            );
            break;
        }
      },
    );
  }
}
