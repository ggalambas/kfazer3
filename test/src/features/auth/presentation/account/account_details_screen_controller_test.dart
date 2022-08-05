import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_screen_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late AccountDetailsScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountDetailsScreenController(
      authRepository: authRepository,
    );
  });
  group('AccountDetailsScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(authRepository.signOut);
      verifyNever(authRepository.deleteUser);
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    test(
      'signOut success',
      () async {
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
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
    test(
      'signOut failure',
      () async {
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
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
    test(
      'deleteUser success',
      () async {
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
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
    test(
      'deleteUser failure',
      () async {
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
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}
