import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/projects/data/projects_repository.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

final projectsServiceProvider = Provider<ProjectsService>((ref) {
  return ProjectsService(ref);
});

class ProjectsService {
  final Ref ref;
  ProjectsService(this.ref);

  GroupsRepository get groupsRepository => ref.read(groupsRepositoryProvider);
  ProjectsRepository get projectsRepository =>
      ref.read(projectsRepositoryProvider);
}

//* Providers

final projectListStreamProvider =
    StreamProvider.family.autoDispose<List<Project>, String>(
  (ref, groupId) async* {
    yield* ref.watch(projectsRepositoryProvider).watchProjectList(groupId);
  },
);
