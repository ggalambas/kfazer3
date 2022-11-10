@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/groups/presentation/details/group_details_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testWorkspaceId = 'id';
  late MockGroupsRepository groupRepository;
  late GroupDetailsController controller;
  setUp(() {
    groupRepository = MockGroupsRepository();
    controller = GroupDetailsController(
      groupsRepository: groupRepository,
    );
  });
  group('GroupDetailsController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => groupRepository.deleteGroup(testWorkspaceId));
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('deleteWorkspace', () {
      test('deleteWorkspace success', () async {
        // setup
        when(() => groupRepository.deleteGroup(testWorkspaceId))
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
        await controller.deleteGroup(testWorkspaceId);
        // verify
        verify(() => groupRepository.deleteGroup(testWorkspaceId)).called(1);
      });
      test('deleteWorkspace failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => groupRepository.deleteGroup(testWorkspaceId))
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
        await controller.deleteGroup(testWorkspaceId);
        // verify
        verify(() => groupRepository.deleteGroup(testWorkspaceId)).called(1);
      });
    });
  });
}
