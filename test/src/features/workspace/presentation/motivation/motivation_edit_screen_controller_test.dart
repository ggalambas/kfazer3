@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_edit_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testWorkspace = Workspace(
    id: 'id',
    title: 'title',
    motivationalMessages: [],
    plan: WorkspacePlan.family,
  );
  late MockWorkspaceRepository workspaceRepository;
  late MotivationEditController controller;
  setUp(() {
    workspaceRepository = MockWorkspaceRepository();
    controller = MotivationEditController(
      workspaceRepository: workspaceRepository,
    );
  });
  group('MotivationEditController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => workspaceRepository.updateWorkspace(testWorkspace));
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('save', () {
      test('save success', () async {
        // setup
        when(() => workspaceRepository.updateWorkspace(testWorkspace))
            .thenAnswer((_) => Future.value());
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            const AsyncData<dynamic>(null),
          ]),
        );
        // run
        await controller.save(testWorkspace);
        // verify
        verify(() => workspaceRepository.updateWorkspace(testWorkspace))
            .called(1);
      });
      test('save failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => workspaceRepository.updateWorkspace(testWorkspace))
            .thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            isA<AsyncError<dynamic>>(),
          ]),
        );
        // run
        await controller.save(testWorkspace);
        // verify
        verify(() => workspaceRepository.updateWorkspace(testWorkspace))
            .called(1);
      });
    });
  });
}
