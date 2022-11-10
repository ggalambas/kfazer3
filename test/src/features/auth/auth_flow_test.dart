@Timeout(Duration(milliseconds: 500))

import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindWelcomeMessage();
    await r.auth.signInWithPhoneNumber();
    r.expectFindAllGroupCards();
    await r.openPopupMenu();
    await r.openSettingsScreen();
    await r.openAccountDetails();
    await r.auth.tapSignOutButton();
    await r.auth.tapDialogSignOutButton();
    r.expectFindWelcomeMessage();
  });
}
