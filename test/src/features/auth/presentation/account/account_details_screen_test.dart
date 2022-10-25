import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
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
    await r.pumpAccountScreen();
    await r.tapSignOutButton();
    r.expectSignOutDialogFound();
    await r.tapDialogSignOutButton();
    r.expectSignOutDialogNotFound();
    r.expectErrorAlertNotFound();
  });
  testWidgets('confirm logout, failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(() => authRepository.currentUser).thenReturn(kTestUsers.first);
    when(authRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(kTestUsers.first));
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapSignOutButton();
    r.expectSignOutDialogFound();
    await r.tapDialogSignOutButton();
    r.expectErrorAlertFound();
  });
  //TODO test confirm logout, loading
  // testWidgets('confirm logout, loading', (tester) async {
  //   final r = AuthRobot(tester);
  //   await tester.runAsync(() async {
  //     await r.pumpAccountScreen();
  //     await r.tapSignOutButton();
  //     r.expectSignOutDialogFound();
  //     await r.tapDialogSignOutButton(skipLoading: false);
  //   });
  //   r.expectCircularProgressIndicatorFound();
  // });
}
