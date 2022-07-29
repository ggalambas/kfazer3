import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/workspace/data/workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class WorkspaceDetailsScreen extends ConsumerWidget {
  final String workspaceId;
  const WorkspaceDetailsScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceValue = ref.watch(workspaceStreamProvider(workspaceId));
    return AsyncValueWidget<Workspace?>(
      value: workspaceValue,
      data: (workspace) {
        if (workspace == null) return const NotFoundWorkspace();
        return Scaffold(
          appBar: DetailsBar(
            title: 'Workspace'.hardcoded,
            onEdit: () => context.goNamed(
              AppRoute.workspaceDetails.name,
              params: {'workspaceId': workspaceId},
              queryParams: {'editing': 'true'},
            ),
            onDelete: () => showNotImplementedAlertDialog(context: context),
          ),
          body: ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: EdgeInsets.all(kSpace * 2),
            child: ListView(
              children: [
                Column(
                  children: [
                    Avatar.fromWorkspace(workspace, radius: kSpace * 10),
                    Space(4),
                    TextFormField(
                      enabled: false,
                      initialValue: workspace.title,
                      decoration: InputDecoration(
                        labelText: 'Title'.hardcoded,
                      ),
                    ),
                    Space(),
                    TextFormField(
                      enabled: false,
                      initialValue: workspace.description,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description'.hardcoded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
