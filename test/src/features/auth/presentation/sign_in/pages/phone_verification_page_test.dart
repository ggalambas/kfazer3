import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';
import '../../../auth_robot.dart';

//TODO resend sms code test
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
}
