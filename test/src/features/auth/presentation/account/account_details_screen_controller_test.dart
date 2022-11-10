@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountDetailsController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountDetailsController(
      authRepository: authRepository,
    );
  });
  group('AccountDetailsController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(authRepository.signOut);
      verifyNever(authRepository.deleteUser);
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('signOut', () {
      test('signOut success', () async {
        // setup
        when(authRepository.signOut).thenAnswer((_) => Future.value());
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            const AsyncData<dynamic>(null),
          ]),
        );
        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
        verifyNever(authRepository.deleteUser);
      });
      test('signOut failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            isA<AsyncError<dynamic>>(),
          ]),
        );
        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
        verifyNever(authRepository.deleteUser);
      });
    });
    group('deleteUser', () {
      test('deleteUser success', () async {
        // setup
        when(authRepository.deleteUser).thenAnswer((_) => Future.value());
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            const AsyncData<dynamic>(null),
          ]),
        );
        // run
        await controller.deleteUser();
        // verify
        verify(authRepository.deleteUser).called(1);
        verifyNever(authRepository.signOut);
      });
      test('deleteUser failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(authRepository.deleteUser).thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            isA<AsyncError<dynamic>>(),
          ]),
        );
        // run
        await controller.deleteUser();
        // verify
        verify(authRepository.deleteUser).called(1);
        verifyNever(authRepository.signOut);
      });
    });
  });
}
