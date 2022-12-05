import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/projects/data/projects_repository.dart';
import 'package:kfazer3/src/features/projects/domain/mutable_project.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

final projectsServiceProvider = Provider<ProjectsService>((ref) {
  return ProjectsService(ref);
});

class ProjectsService {
  final Ref ref;
  ProjectsService(this.ref);

  AuthRepository get authRepository => ref.read(authRepositoryProvider);
  GroupsRepository get groupsRepository => ref.read(groupsRepositoryProvider);
  ProjectsRepository get projectsRepository =>
      ref.read(projectsRepositoryProvider);

  Future<void> leaveProject(Project project) async {
    final currentUser = authRepository.currentUser!;
    final copy = project.removeMemberById(currentUser.id);
    await projectsRepository.updateProject(copy);
  }
}

//* Providers

final projectListStreamProvider =
    StreamProvider.family.autoDispose<List<Project>, String>(
  (ref, groupId) async* {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      yield* ref
          .watch(projectsRepositoryProvider)
          .watchProjectList(user.id, groupId);
    }
  },
);
