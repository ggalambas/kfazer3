import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  final testUser = kTestUsers.first;
  const testCountry =
      Country(code: 'PT', name: 'Portugal', phoneCode: '+351', flagUrl: '');
  final testPhoneNumber = PhoneNumber(testCountry.code, '912345678');
  late MockAuthRepository authRepository;
  late MockCountryRepository countryRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    countryRepository = MockCountryRepository();
    registerFallbackValue(testPhoneNumber);
  });

  group('sign in', () {
    //TODO this is giving constraints error (7. Automated Testing > 9)
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
  });
}
