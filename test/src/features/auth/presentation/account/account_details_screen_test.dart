@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

//TODO test other account screen actions

void main() {
  late AuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
    when(() => authRepository.currentUser).thenReturn(kTestUsers.first);
    when(authRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(kTestUsers.first));
  });

  testWidgets('cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapSignOutButton();
    r.expectSignOutDialogFound();
    await r.tapCancelButton();
    r.expectSignOutDialogNotFound();
  });
  testWidgets('confirm logout, success', (tester) async {
    final r = AuthRobot(tester);
    when(authRepository.signOut).thenAnswer((_) async {});
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapSignOutButton();
    r.expectSignOutDialogFound();
    await r.tapDialogSignOutButton();
    r.expectSignOutDialogNotFound();
    r.expectErrorAlertNotFound();
  });
  testWidgets('confirm logout, failure', (tester) async {
    final r = AuthRobot(tester);
    final exception = Exception();
    when(authRepository.signOut).thenThrow(exception);
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapSignOutButton();
    r.expectSignOutDialogFound();
    await r.tapDialogSignOutButton();
    r.expectErrorAlertFound();
    r.expectSignOutDialogNotFound();
  });
}
