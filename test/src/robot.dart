import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/app.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/fake_auth_repository.dart';

import 'features/auth/auth_robot.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot auth;
  Robot(this.tester) : auth = AuthRobot(tester);

  Future<void> pumpMyApp() async {
    final authRepository = FakeAuthRepository(
      addDelay: false,
      startSignedIn: false,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
        child: const MyApp(),
      ),
    );
  }

  void expectWelcomeFound() {
    final welcome = find.textContaining('Welcome');
    expect(welcome, findsOneWidget);
  }
}
