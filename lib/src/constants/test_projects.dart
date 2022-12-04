import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

/// Test projects to be used until a data source is implemented
List<Project> get kTestProjects => [..._kTestProjects];
final _kTestProjects = [
  for (final group in kTestGroups)
    ...List.generate(
      2,
      (i) => Project(
        id: '$i',
        title: 'Project $i',
        description: 'A project made by him about world problem solving.',
        members: group.members.keys.toList(),
        groupId: group.id,
      ),
    ),
];
