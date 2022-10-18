import 'package:flutter_test/flutter_test.dart';

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
}
