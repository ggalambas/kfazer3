// @Timeout(Duration(milliseconds: 500))

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:kfazer3/src/features/groups/domain/group.dart';
// import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
// import 'package:kfazer3/src/features/groups/presentation/details/group_edit_controller.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../../../mocks.dart';

// void main() {
//   const testGroup = Group(
//     id: 'id',
//     title: 'title',
//     plan: GroupPlan.family,
//     memberIds: [],
//   );
//   late MockGroupsRepository groupsRepository;
//   late GroupEditController controller;
//   setUp(() {
//     groupsRepository = MockGroupsRepository();
//     controller = GroupEditController(
//       groupsRepository: groupsRepository,
//     );
//   });
//   group('GroupEditController', () {
//     test('initial state is AsyncValue.data', () {
//       verifyNever(() => groupsRepository.updateGroup(testGroup));
//       expect(controller.debugState, const AsyncData<dynamic>(null));
//     });
//     group('save', () {
//       test('save success', () async {
//         // setup
//         when(() => groupsRepository.updateGroup(testGroup))
//             .thenAnswer((_) => Future.value());
//         // expect later
//         expectLater(
//           controller.stream,
//           emitsInOrder([
//             const AsyncLoading<dynamic>(),
//             const AsyncData<dynamic>(null),
//           ]),
//         );
//         // run
//         await controller.save(testGroup, null);
//         // verify
//         verify(() => groupsRepository.updateGroup(testGroup)).called(1);
//       });
//       test('save failure', () async {
//         // setup
//         final exception = Exception('Connection failed');
//         when(() => groupsRepository.updateGroup(testGroup))
//             .thenThrow(exception);
//         // expect later
//         expectLater(
//           controller.stream,
//           emitsInOrder([
//             const AsyncLoading<dynamic>(),
//             isA<AsyncError<dynamic>>(),
//           ]),
//         );
//         // run
//         await controller.save(testGroup, null);
//         // verify
//         verify(() => groupsRepository.updateGroup(testGroup)).called(1);
//       });
//     });
//   });
// }
