@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_details/workspace_details_screen_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testWorkspaceId = 'id';
  late MockWorkspaceRepository workspaceRepository;
  late WorkspaceDetailsScreenController controller;
  setUp(() {
    workspaceRepository = MockWorkspaceRepository();
    controller = WorkspaceDetailsScreenController(
      workspaceRepository: workspaceRepository,
    );
  });
  group('WorkspaceDetailsScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => workspaceRepository.deleteWorkspace(testWorkspaceId));
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('deleteWorkspace', () {
      test('deleteWorkspace success', () async {
        // setup
        when(() => workspaceRepository.deleteWorkspace(testWorkspaceId))
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
        await controller.deleteWorkspace(testWorkspaceId);
        // verify
        verify(() => workspaceRepository.deleteWorkspace(testWorkspaceId))
            .called(1);
      });
      test('deleteWorkspace failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => workspaceRepository.deleteWorkspace(testWorkspaceId))
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
        await controller.deleteWorkspace(testWorkspaceId);
        // verify
        verify(() => workspaceRepository.deleteWorkspace(testWorkspaceId))
            .called(1);
      });
    });
  });
}
