@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';
import '../../../auth_robot.dart';

void main() {
  const testCountry =
      Country(code: 'PT', name: 'Portugal', phoneCode: '+351', flagUrl: '');
  final testPhoneNumber = PhoneNumber(testCountry.phoneCode, '912345678');
  late MockAuthRepository authRepository;
  late MockCountryRepository countryRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    countryRepository = MockCountryRepository();
    when(countryRepository.fetchCountryList)
        .thenAnswer((_) async => [testCountry]);

    registerFallbackValue(testPhoneNumber);
  });

  testWidgets('''
    Given page is phone
    When tap on submit button
    Then sendSmsCode is not called
    And required alert is shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpPhoneSignInPage(
      authRepository: authRepository,
      countryRepository: countryRepository,
    );
    await r.tapSignInSubmitButton();
    verifyNever(() => authRepository.sendSmsCode(any()));
    r.expectRequiredTextFound();
  });
  testWidgets('''
    Given page is phone
    When enter invalid phone number
    And tap on submit button
    Then sendSmsCode is not called
    And numbers alert is shown
    ''', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpPhoneSignInPage(
      authRepository: authRepository,
      countryRepository: countryRepository,
    );
    await r.enterPhoneNumber('not a number');
    await r.tapSignInSubmitButton();
    verifyNever(() => authRepository.sendSmsCode(any()));
    r.expectNumbersTextFound();
  });
  testWidgets('''
    Given page is phone
    When enter valid phone number
    And tap on submit button
    Then sendSmsCode is called
    And error alert is not shown
    And onSuccess callback is called
    ''', (tester) async {
    var didSignIn = false;
    final r = AuthRobot(tester);
    when(() => authRepository.sendSmsCode(testPhoneNumber))
        .thenAnswer((_) async {});
    await r.pumpPhoneSignInPage(
      authRepository: authRepository,
      countryRepository: countryRepository,
      onSignedIn: () => didSignIn = true,
    );
    await r.enterPhoneNumber(testPhoneNumber.number);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
    r.expectErrorAlertNotFound();
    expect(didSignIn, true);
  });
  testWidgets('''
    Given page is phone
    When enter valid phone number
    And tap on submit button
    Then sendSmsCode fails
    And error alert is shown
    And onSuccess callback is not called
    ''', (tester) async {
    var didSignIn = false;
    final r = AuthRobot(tester);
    final exception = Exception();
    when(() => authRepository.sendSmsCode(testPhoneNumber))
        .thenThrow(exception);
    await r.pumpPhoneSignInPage(
      authRepository: authRepository,
      countryRepository: countryRepository,
      onSignedIn: () => didSignIn = true,
    );
    await r.enterPhoneNumber(testPhoneNumber.number);
    await r.tapSignInSubmitButton();
    verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
    r.expectErrorAlertFound();
    expect(didSignIn, false);
  });
}
