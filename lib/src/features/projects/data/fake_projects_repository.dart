import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_projects.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';
import 'package:kfazer3/src/utils/delay.dart';
import 'package:kfazer3/src/utils/in_memory_store.dart';

import 'projects_repository.dart';

class FakeProjectsRepository implements ProjectsRepository {
  // An InMemoryStore containing all the projects.
  // final _projects = InMemoryStore<List<Project>>([]);
  final _projects = InMemoryStore<List<Project>>(kTestProjects);
  void dispose() => _projects.close();

  final bool addDelay;
  FakeProjectsRepository({this.addDelay = true});

  @override
  Stream<List<Project>> watchProjectList(String groupId) async* {
    await delay(addDelay);
    yield* _projects.stream.map(
      (projects) => projects.where((project) {
        return project.groupId == groupId;
      }).toList(),
    );
  }

  @override
  Stream<Project?> watchProject(String id) async* {
    yield* _projects.stream.map(
      (projects) => projects.firstWhereOrNull(
        (project) => project.id == id,
      ),
    );
  }

  @override
  Future<void> createProject(Project project) async {
    await delay(addDelay);
    // First, get the project list
    final projects = _projects.value;
    // Then, add the project
    projects.add(project);
    // Finally, update the notification list data (will emit a new value)
    _projects.value = projects;
  }

  @override
  Future<void> updateProject(Project project) async {
    await delay(addDelay);
    // First, get the project list
    final projects = _projects.value;
    // Then, change the project
    final i = projects.indexWhere((g) => project.id == g.id);
    projects[i] = project;
    // Finally, update the project list data (will emit a new value)
    _projects.value = projects;
  }

  @override
  Future<void> deleteProject(String id) async {
    await delay(addDelay);
    // First, get the project list
    final projects = _projects.value;
    // Then, delete the project
    projects.removeWhere((g) => id == g.id);
    // Finally, update the project list data (will emit a new value)
    _projects.value = projects;
  }
}
