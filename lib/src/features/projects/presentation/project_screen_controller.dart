import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/projects/application/projects_service.dart';
import 'package:kfazer3/src/features/projects/domain/project.dart';

final projectScreenControllerProvider =
    StateNotifierProvider.autoDispose<ProjectScreenController, AsyncValue>(
  (ref) => ProjectScreenController(
    projectsService: ref.watch(projectsServiceProvider),
  ),
);

class ProjectScreenController extends StateNotifier<AsyncValue> {
  final ProjectsService projectsService;

  ProjectScreenController({required this.projectsService})
      : super(const AsyncValue.data(null));

  Future<bool> leaveProject(Project project) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => projectsService.leaveProject(project));
    return !state.hasError;
  }
}
