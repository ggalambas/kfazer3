import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/task_grid.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:smart_space/smart_space.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.archive)),
      body: CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            padding: EdgeInsets.all(kSpace),
            child: const TaskGrid(
              taskState: TaskState.archived,
            ),
          ),
        ],
      ),
    );
  }
}
