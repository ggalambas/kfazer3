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

class AuthRobot {
  final WidgetTester tester;
  AuthRobot(this.tester);

  Future<void> pumpSignInScreen({
    required AuthRepository authRepository,
    required CountryRepository countryRepository,
    VoidCallback? onSignedIn,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          countryRepositoryProvider.overrideWithValue(countryRepository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PhoneSignInPage(onSuccess: onSignedIn),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
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
    final phoneField = find.byType(TextFormField);
    expect(phoneField, findsOneWidget);
    await tester.enterText(phoneField, number);
    await tester.pump();
  }

  Future<void> enterCode(String code) async {
    final codeField = find.byType(TextFormField);
    expect(codeField, findsOneWidget);
    await tester.enterText(codeField, code);
    await tester.pump();
  }

  Future<void> enterDisplayName(String name) async {
    final nameField = find.byType(TextFormField);
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, name);
    await tester.pump();
  }

  Future<void> signInWithPhoneNumber() async {
    await enterPhoneNumber('912345678');
    await tapSignInSubmitButton();
    await enterCode('123456');
    await tapSignInSubmitButton();
    await enterDisplayName('Display Name');
    await tapSignInSubmitButton();
  }

  void expectRequiredTextFound() {
    final requiredText = find.textContaining('required');
    expect(requiredText, findsOneWidget);
  }

  void expectNumbersTextFound() {
    final numbersText = find.textContaining('numbers');
    expect(numbersText, findsOneWidget);
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
    await tester.pumpAndSettle();
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapDialogSignOutButton() async {
    final signOutButton = find.byKey(kDialogDefaultKey);
    expect(signOutButton, findsOneWidget);
    await tester.tap(signOutButton);
    await tester.pumpAndSettle();
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
}
