@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  late MockAuthRepository authRepository;
  late SmsCodeController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = SmsCodeController(
      testPhoneNumber,
      authRepository: authRepository,
    );
  });
  group('SmsCodeController', () {
    test('initial state', () {
      expect(controller.debugState, const AsyncData<int>(0));
      expect(controller.isTicking, false);
      expect(controller.timer.isActive, true);
      verifyNever(() => authRepository.sendSmsCode(testPhoneNumber));
    });
    test('dispose', () {
      // run
      controller.dispose();
      // verify
      expect(controller.timer.isActive, false);
    });
    group('sendSmsCode', () {
      test('sendSmsCode success', () async {
        // setup
        when(() => authRepository.sendSmsCode(testPhoneNumber))
            .thenAnswer((_) => Future.value());
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading(),
            AsyncData(kCodeTimerDuration.inSeconds),
          ]),
        );
        // run
        await controller.sendSmsCode();
        // verify
        expect(controller.isTicking, true);
        verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
      });
      test('sendSmsCode failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => authRepository.sendSmsCode(testPhoneNumber))
            .thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([const AsyncLoading(), isA<AsyncError>()]),
        );
        // run
        await controller.sendSmsCode();
        // verify
        expect(controller.isTicking, false);
        verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
      });
      test('sendSmsCode thorws failure', () async {
        // setup
        final exception = Exception('Connection failed');
        when(() => authRepository.sendSmsCode(testPhoneNumber))
            .thenThrow(exception);
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([const AsyncLoading(), isA<AsyncError>()]),
        );
        // run
        expect(() => controller.sendSmsCode(throwError: true), throwsException);
        // verify
        expect(controller.isTicking, false);
        verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
      });
      test('sendSmsCode cannot execute yet', () async {
        // setup
        when(() => authRepository.sendSmsCode(testPhoneNumber))
            .thenAnswer((_) => Future.value());
        // expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading(),
            AsyncData(kCodeTimerDuration.inSeconds),
          ]),
        );
        // run
        await controller.sendSmsCode();
        await controller.sendSmsCode();
        // verify
        expect(controller.isTicking, true);
        verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
      });
    });
  });
}
