import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

/// Test workspaces to be used until a data source is implemented
final kTestWorkspaces = List.generate(
  2,
  (i) => Workspace(
    id: '$i',
    title: 'Workspace $i',
    description:
        'A workspace made by him for the company x in the center of the world.',
  ),
);
