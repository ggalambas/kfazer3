import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/fake_repositories_delay.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

import 'fake_projects_repository.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) {
    final repository = FakeProjectsRepository(addDelay: addRepositoryDelay);
    ref.onDispose(() => repository.dispose());
    return repository;
  },
);

abstract class ProjectsRepository {
  Stream<List<Project>> watchProjectList(String userId, String groupId);
  Stream<Project?> watchProject(String id);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String id);
}

//* Providers

//? should this return null or throw an error when project not found
final projectStreamProvider =
    StreamProvider.autoDispose.family<Project?, String>(
  (ref, id) {
    final repository = ref.watch(projectsRepositoryProvider);
    return repository.watchProject(id);
  },
);
