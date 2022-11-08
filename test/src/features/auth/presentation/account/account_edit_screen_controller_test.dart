@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_edit_screen_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  const testName = 'Jimmy Hawkins';
  final testUser = AppUser(
    id: testPhoneNumber.full,
    phoneNumber: testPhoneNumber,
    name: testName,
  );
  late MockAuthRepository authRepository;
  late AccountEditScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountEditScreenController(
      authRepository: authRepository,
    );
  });
  group('AccountEditScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(() => authRepository.updateUser(testUser));
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('save', () {
      test('save success', () async {
        // setup
        when(() => authRepository.updateUser(testUser))
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
        await controller.save(testUser, null);
        // verify
        verify(() => authRepository.updateUser(testUser)).called(1);
      });
      test('save failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => authRepository.updateUser(testUser)).thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<dynamic>(),
            isA<AsyncError<dynamic>>(),
          ]),
        );
        // run
        await controller.save(testUser, null);
        // verify
        verify(() => authRepository.updateUser(testUser)).called(1);
      });
    });
  });
}
