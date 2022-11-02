import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/pages/phone_sign_in_page.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';

class AuthRobot {
  final WidgetTester tester;
  AuthRobot(this.tester);

  Future<void> pumpSignInScreen({
    required AuthRepository authRepository,
    required CountryRepository countryRepository,
    required SignInPage page,
    VoidCallback? onSignedIn,
  }) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          countryRepositoryProvider.overrideWithValue(countryRepository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignInScreen(page: page),
        ),
      ),
    );
  }

  Future<void> tapSignInSubmitButton() async {
    final button = find.byType(LoadingElevatedButton);
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  // Future<void> enterPhoneCode(String code) async {
  //   // open country picker dialog
  //   final button = find.byType(PhoneCodeDropdownButton);
  //   expect(button, findsOneWidget);
  //   await tester.tap(button);
  //   await tester.pump();
  //   // search the code
  //   final countrySearchField = find.byType(CountrySearchField);
  //   expect(countrySearchField, findsOneWidget);
  //   await tester.enterText(countrySearchField, code);
  //   // tap on the correspondent country
  //   final country = find.text('Portugal');
  //   expect(country, findsOneWidget);
  //   await tester.tap(country);
  //   await tester.pump();
  // }

  Future<void> enterPhoneNumber(String number) async {
    final phoneField = find.byKey(PhoneSignInPage.phoneKey);
    expect(phoneField, findsOneWidget);
    await tester.enterText(phoneField, number);
    await tester.pump();
  }

  Future<void> pumpAccountScreen({AuthRepository? authRepository}) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AccountDetailsScreen(),
        ),
      ),
    );
  }

  Future<void> tapSignOutButton() async {
    final signOutButton = find.text('Sign Out');
    expect(signOutButton, findsOneWidget);
    await tester.tap(signOutButton);
    await tester.pump();
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
  }

  Future<void> tapDialogSignOutButton({bool skipLoading = true}) async {
    final signOutButton = find.byKey(kDialogDefaultKey);
    expect(signOutButton, findsOneWidget);
    await tester.tap(signOutButton);
    skipLoading ? await tester.pumpAndSettle() : await tester.pump();
  }

  void expectSignOutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  void expectSignOutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlertFound() {
    final error = find.text('Error');
    expect(error, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final error = find.text('Error');
    expect(error, findsNothing);
  }

  void expectCircularProgressIndicatorFound() {
    final loading = find.byType(CircularProgressIndicator);
    expect(loading, findsOneWidget);
  }
}
