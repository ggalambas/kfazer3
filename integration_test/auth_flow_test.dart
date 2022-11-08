@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindWelcomeMessage();
    await r.auth.signInWithPhoneNumber();
    r.expectFindAllWorkspaceCards();
    await r.openPopupMenu();
    await r.openSettingsScreen();
    await r.openAccountDetails();
    await r.auth.tapSignOutButton();
    await r.auth.tapDialogSignOutButton();
    r.expectFindWelcomeMessage();
  });
}
