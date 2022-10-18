import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  final testUser = kTestUsers.first;
  late MockAuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('sign in', () {
    //TODO this is giving constraints error (7. Automated Testing > 9)
    testWidgets(
        '''
    Given page is phone
    When tap on submit button
    Then sendSmsCode is not called
    ''',
        (tester) async {
      final r = AuthRobot(tester);
      await r.pumpSignInScreen(
        authRepository: authRepository,
        page: SignInPage.phone,
      );
      await r.tapSignInSubmitButton();
      verifyNever(() => authRepository.verifySmsCode(any(), any()));
    });
  });
}
