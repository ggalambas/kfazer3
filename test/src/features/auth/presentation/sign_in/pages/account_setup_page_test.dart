@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';
import '../../../auth_robot.dart';

void main() {
  const testName = 'Display Name';
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  final payload = SignInPayload()
    ..phoneNumber = testPhoneNumber
    ..isCodeValid = true;
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    registerFallbackValue(testPhoneNumber);
    registerFallbackValue(testName);
  });

  testWidgets('''
    Given page is account
    When tap on submit button
    Then createUser is not called
    And alert is shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountSetupPage(
      authRepository: authRepository,
      payload: payload,
    );
    await r.tapSignInSubmitButton();
    verifyNever(() => authRepository.createUser(any(), any()));
    r.expectRequiredTextFound();
  });
  testWidgets('''
    Given page is account
    When enter valid name
    And tap on submit button
    Then createUser is called
    And error alert is not shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    when(() => authRepository.createUser(testPhoneNumber, testName))
        .thenAnswer((_) async {});
    await r.pumpAccountSetupPage(
      authRepository: authRepository,
      payload: payload,
    );
    await r.enterDisplayName(testName);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.createUser(testPhoneNumber, testName))
        .called(1);
    r.expectErrorAlertNotFound();
  });
  testWidgets('''
    Given page is account
    When enter valid name
    And tap on submit button
    Then createUser fails
    And error alert is shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    final exception = Exception();
    when(() => authRepository.createUser(testPhoneNumber, testName))
        .thenThrow(exception);
    await r.pumpAccountSetupPage(
      authRepository: authRepository,
      payload: payload,
    );
    await r.enterDisplayName(testName);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.createUser(testPhoneNumber, testName))
        .called(1);
    r.expectErrorAlertFound();
  });
}
