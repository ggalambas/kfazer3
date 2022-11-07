import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/app.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/data/fake_auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:mocktail/mocktail.dart';

import 'features/auth/auth_robot.dart';
import 'mocks.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot auth;
  Robot(this.tester) : auth = AuthRobot(tester);

  Future<void> pumpMyApp() async {
    final authRepository = FakeAuthRepository(
      addDelay: false,
      startSignedIn: false,
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
          countryRepositoryProvider.overrideWithValue(countryRepository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectWelcomeFound() {
    final welcome = find.textContaining('Welcome');
    expect(welcome, findsOneWidget);
  }
}
