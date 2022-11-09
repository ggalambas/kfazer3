import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/app.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/data/fake_auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/notifications/data/fake_notifications_repository.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/settings/presentation/settings_screen.dart';
import 'package:kfazer3/src/features/workspace/data/fake_workspaces_repository.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/workspace_card.dart';
import 'package:mocktail/mocktail.dart';

import 'features/auth/auth_robot.dart';
import 'goldens/golden_robot.dart';
import 'mocks.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot auth;
  final GoldenRobot golden;

  Robot(this.tester)
      : auth = AuthRobot(tester),
        golden = GoldenRobot(tester);

  Future<void> pumpMyApp({bool startSignedIn = false}) async {
    final authRepository = FakeAuthRepository(
      addDelay: false,
      startSignedIn: startSignedIn,
    );
    final workspaceRepository = FakeWorkspaceRepository(
      addDelay: false,
    );
    final notificationsRepository = FakeNotificationsRepository(
      addDelay: false,
    );
    final countryRepository = MockCountryRepository();
    const testCountry = Country(
      code: 'PT',
      name: 'Portugal',
      phoneCode: '+351',
      flagUrl: '',
    );
    when(countryRepository.fetchCountryList)
        .thenAnswer((_) async => [testCountry]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          workspaceRepositoryProvider.overrideWithValue(workspaceRepository),
          notificationsRepositoryProvider
              .overrideWithValue(notificationsRepository),
          countryRepositoryProvider.overrideWithValue(countryRepository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindVerifyMessage() {
    final verify = find.textContaining('verify');
    expect(verify, findsOneWidget);
  }

  void expectFindWelcomeMessage() {
    final welcome = find.textContaining('Welcome');
    expect(welcome, findsOneWidget);
  }

  void expectFindAllWorkspaceCards() {
    final cards = find.byType(WorkspaceCard);
    expect(cards, findsNWidgets(kTestWorkspaces.length));
  }

  Future<void> openPopupMenu() async {
    final button = find.byType(SingleChildMenuButton);
    // final matches = button.evaluate();
    // if (matches.isNotEmpty) {
    await tester.tap(button);
    await tester.pumpAndSettle();
    // }
  }

  Future<void> openSettingsScreen() async {
    final settings = find.text('Settings');
    expect(settings, findsOneWidget);
    await tester.tap(settings);
    await tester.pumpAndSettle();
  }

  Future<void> openAccountDetails() async {
    final accountDetails = find.byKey(SettingsScreen.accountDetailsKey);
    expect(accountDetails, findsOneWidget);
    await tester.tap(accountDetails);
    await tester.pumpAndSettle();
  }
}
