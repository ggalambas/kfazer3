@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';
import '../../../auth_robot.dart';

void main() {
  const testCode = '123456';
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  final payload = SignInPayload()..phoneNumber = testPhoneNumber;
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    registerFallbackValue(testPhoneNumber);
    registerFallbackValue(testCode);
  });

  testWidgets('''
    Given page is verification
    When tap on submit button
    Then verifySmsCode is not called
    And alert is shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpPhoneVerificationPage(
      authRepository: authRepository,
      payload: payload,
    );
    await r.tapSignInSubmitButton();
    verifyNever(() => authRepository.verifySmsCode(any(), any()));
    r.expectCharactersTextFound();
  });
  testWidgets('''
    Given page is verification
    When enter valid code
    And tap on submit button
    Then verifySmsCode is called
    And error alert is not shown
    And onSuccess callback is called
    ''', (tester) async {
    var didVerify = false;
    final r = AuthRobot(tester);
    when(() => authRepository.verifySmsCode(testPhoneNumber, testCode))
        .thenAnswer((_) async {});
    await r.pumpPhoneVerificationPage(
      authRepository: authRepository,
      payload: payload,
      onVerified: () => didVerify = true,
    );
    await r.enterCode(testCode);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.verifySmsCode(testPhoneNumber, testCode))
        .called(1);
    r.expectErrorAlertNotFound();
    expect(didVerify, true);
  });
  testWidgets('''
    Given page is verification
    When enter valid code
    And tap on submit button
    Then verifySmsCode fails
    And error alert is shown
    And onSuccess callback is not called
    ''', (tester) async {
    var didVerify = false;
    final r = AuthRobot(tester);
    final exception = Exception();
    when(() => authRepository.verifySmsCode(testPhoneNumber, testCode))
        .thenThrow(exception);
    await r.pumpPhoneVerificationPage(
      authRepository: authRepository,
      payload: payload,
      onVerified: () => didVerify = true,
    );
    await r.enterCode(testCode);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.verifySmsCode(testPhoneNumber, testCode))
        .called(1);
    r.expectErrorAlertFound();
    expect(didVerify, false);
  });

  group('resend sms code', () {
    late SmsCodeController smsCodeController;

    setUp(() {
      smsCodeController = SmsCodeController(
        testPhoneNumber,
        authRepository: authRepository,
      );
    });

    tearDown(() {
      smsCodeController.dispose();
    });

    testWidgets('''
    Given page is verification
    When code timer is ticking
    And tap on resend sms button
    Then sendSmsCode is not called
    ''', (tester) async {
      when(() => authRepository.sendSmsCode(testPhoneNumber))
          .thenAnswer((_) async {});
      await smsCodeController.sendSmsCode();
      final r = AuthRobot(tester);
      await r.pumpPhoneVerificationPage(
        authRepository: authRepository,
        payload: payload,
        smsCodeController: smsCodeController,
      );
      await r.tapResendSmsButton();
      verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
    });
    testWidgets('''
    Given page is verification
    When code timer is not ticking
    And tap on resend sms button
    Then sendSmsCode is called
    ''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpPhoneVerificationPage(
        authRepository: authRepository,
        payload: payload,
        smsCodeController: smsCodeController,
      );
      await r.tapResendSmsButton();
      verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
    });
  });
}
