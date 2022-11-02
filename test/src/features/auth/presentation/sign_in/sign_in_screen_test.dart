import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

//TODO finish this page tests
//
// example
// client side validation for phone number
// sign in failure

void main() {
  final testUser = kTestUsers.first;
  const testCountry =
      Country(code: 'PT', name: 'Portugal', phoneCode: '+351', flagUrl: '');
  final testPhoneNumber = PhoneNumber(testCountry.phoneCode, '912345678');
  late MockAuthRepository authRepository;
  late MockCountryRepository countryRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    countryRepository = MockCountryRepository();
    registerFallbackValue(testPhoneNumber);
  });

  group('sign in', () {
    testWidgets('''
    Given page is phone
    When tap on submit button
    Then sendSmsCode is not called
    ''', (tester) async {
      final r = AuthRobot(tester);

      when(countryRepository.fetchCountryList)
          .thenAnswer((_) async => [testCountry]);

      await r.pumpSignInScreen(
        authRepository: authRepository,
        countryRepository: countryRepository,
        page: SignInPage.phone,
      );
      await tester.pumpAndSettle();
      await r.tapSignInSubmitButton();
      verifyNever(() => authRepository.sendSmsCode(any()));
    });
    testWidgets('''
    Given page is phone
    When enter valid phone number
    And tap on submit button
    Then sendSmsCode is called
    And onSuccess callback is called
    And error alert is not shown
    ''', (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.sendSmsCode(testPhoneNumber))
          .thenAnswer((_) => Future.value());

      when(countryRepository.fetchCountryList)
          .thenAnswer((_) async => [testCountry]);

      await r.pumpSignInScreen(
        authRepository: authRepository,
        countryRepository: countryRepository,
        onSignedIn: () => didSignIn = true,
        page: SignInPage.phone,
      );
      await tester.pumpAndSettle();
      await r.enterPhoneNumber(testPhoneNumber.number);
      await r.tapSignInSubmitButton();
      verify(() => authRepository.sendSmsCode(testPhoneNumber)).called(1);
      r.expectErrorAlertNotFound();
      expect(didSignIn, true);
    });
  });
}
