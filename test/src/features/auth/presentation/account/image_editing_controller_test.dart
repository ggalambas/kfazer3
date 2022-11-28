// @Timeout(Duration(milliseconds: 500))

// import 'dart:typed_data';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:kfazer3/src/common_widgets/image_editing_controller.dart';
// import 'package:mocktail/mocktail.dart';

// import '../../../../mocks.dart';

// void main() {
//   final testFile = MockXFile();
//   late ImageEditingController controller;
//   setUp(() {
//     controller = ImageEditingController();
//   });
//   group('ImageEditingController', () {
//     test('initial state is AsyncValue.data', () {
//       verifyNever(testFile.readAsBytes);
//       expect(controller.debugState, const AsyncData<dynamic>(null));
//     });
//     group('readAsBytes', () {
//       test('readAsBytes success', () async {
//         // setup
//         final bytes = Uint8List(8);
//         when(testFile.readAsBytes).thenAnswer((_) async => bytes);
//         // expect later
//         expectLater(
//           controller.stream,
//           emitsInOrder([
//             const AsyncLoading<dynamic>(),
//             AsyncData<dynamic>(bytes),
//           ]),
//         );
//         // run
//         await controller.readAsBytes(testFile);
//         // verify
//         verify(testFile.readAsBytes).called(1);
//       });
//       test('readAsBytes failure', () async {
//         // setup
//         final exception = Exception('Connection failed');
//         when(testFile.readAsBytes).thenThrow(exception);
//         // expect later
//         expectLater(
//           controller.stream,
//           emitsInOrder([
//             const AsyncLoading<dynamic>(),
//             isA<AsyncError<dynamic>>(),
//           ]),
//         );
//         // run
//         await controller.readAsBytes(testFile);
//         // verify
//         verify(testFile.readAsBytes).called(1);
//       });
//     });
//   });
// }
