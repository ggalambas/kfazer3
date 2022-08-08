@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testWorkspaceId = 'id';
  late MockWorkspaceRepository workspaceRepository;
  late WorkspaceScreenController controller;
  setUp(() {
    workspaceRepository = MockWorkspaceRepository();
    controller = WorkspaceScreenController(
      workspaceRepository: workspaceRepository,
    );
  });
  group('WorkspaceScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => workspaceRepository.leaveWorkspace(testWorkspaceId));
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('leave', () {
      test('leave success', () async {
        // setup
        when(() => workspaceRepository.leaveWorkspace(testWorkspaceId))
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
        await controller.leave(testWorkspaceId);
        // verify
        verify(() => workspaceRepository.leaveWorkspace(testWorkspaceId))
            .called(1);
      });
      test('leave failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => workspaceRepository.leaveWorkspace(testWorkspaceId))
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
        await controller.leave(testWorkspaceId);
        // verify
        verify(() => workspaceRepository.leaveWorkspace(testWorkspaceId))
            .called(1);
      });
    });
  });
}
