@Timeout(Duration(milliseconds: 500))

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  const testName = 'Jimmy Hawkins';
  const testCode = '123456';
  late MockAuthRepository authRepository;
  late SmsCodeController smsCodeController;
  late SignInController controller;

  setUpAll(() {
    authRepository = MockAuthRepository();
    smsCodeController = MockSmsCodeController();
    controller = SignInController(
      authRepository: authRepository,
      smsCodeController: (_) => smsCodeController,
    );
  });

  Future<void> testSuccess(
    SignInPage page,
    Function() method,
    dynamic value,
  ) async {
    // setup
    when(method).thenAnswer((_) => Future.value());
    // expect later
    expect(
      controller.stream,
      emitsInOrder([
        const AsyncLoading<dynamic>(),
        const AsyncData<dynamic>(null),
      ]),
    );
    // run
    final result = await controller.submit(page, value);
    // verify
    expect(result, true);
    verify(method).called(1);
  }

  Future<void> testFailure(
    SignInPage page,
    Function() method,
    dynamic value,
  ) async {
    // setup
    final exception = Exception('Connection failed');
    when(method).thenThrow(exception);
    // expect later
    expect(
      controller.stream,
      emitsInOrder([
        const AsyncLoading<dynamic>(),
        isA<AsyncError<dynamic>>(),
      ]),
    );
    // run
    final result = await controller.submit(page, value);
    // verify
    expect(result, false);
    verify(method).called(1);
  }

  group('SignInController', () {
    test('initial state is AsyncValue.data', () {
      expect(controller.debugState, const AsyncData<dynamic>(null));
    });
    group('sendSmsCode', () {
      test(
        'Given signInPage is phone'
        'When sendSmsCode succeeds'
        'Then return true'
        'And state is AsyncData',
        () => testSuccess(
          SignInPage.phone,
          () => smsCodeController.sendSmsCode(throwError: true),
          testPhoneNumber,
        ),
      );
      test(
        'Given signInPage is phone'
        'When sendSmsCode fails'
        'Then return false'
        'And state is AsyncError',
        () => testFailure(
          SignInPage.phone,
          () => smsCodeController.sendSmsCode(throwError: true),
          testPhoneNumber,
        ),
      );
    });
    group('verifySmsCode', () {
      test(
        'Given signInPage is verification'
        'When verifySmsCode succeeds'
        'Then return true'
        'And state is AsyncData',
        () => testSuccess(
          SignInPage.verification,
          () => authRepository.verifySmsCode(testPhoneNumber, testCode),
          testCode,
        ),
      );
      test(
        'Given signInPage is verification'
        'When verifySmsCode fails'
        'Then return false'
        'And state is AsyncError',
        () => testFailure(
          SignInPage.verification,
          () => authRepository.verifySmsCode(testPhoneNumber, testCode),
          testCode,
        ),
      );
    });
    group('createUser', () {
      test(
        'Given signInPage is account'
        'When createUser succeeds'
        'Then return true'
        'And state is AsyncData',
        () => testSuccess(
          SignInPage.account,
          () => authRepository.createUser(testPhoneNumber, testName),
          testName,
        ),
      );
      test(
        'Given signInPage is account'
        'When createUser fails'
        'Then return false'
        'And state is AsyncError',
        () => testFailure(
          SignInPage.account,
          () => authRepository.createUser(testPhoneNumber, testName),
          testName,
        ),
      );
    });
  });
}
