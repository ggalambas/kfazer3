import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

import 'sign_in_screen.dart';

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>(
  (ref) => SignInController(read: ref.read),
);

class SignInController extends StateNotifier<AsyncValue> with SignInValidators {
  final Reader read;
  String? phoneNumber;

  SignInController({required this.read}) : super(const AsyncValue.data(null));

  AuthRepository get authRepository => read(authRepositoryProvider);

  Future<bool> submit(SignInPage page, String value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      switch (page) {
        case SignInPage.phone:
          return read(smsCodeControllerProvider(value).notifier).sendSmsCode();
        case SignInPage.verification:
          return authRepository.verifySmsCode(phoneNumber!, value);
        case SignInPage.account:
          return authRepository.createAccount(phoneNumber!, value);
      }
    });
    if (page == SignInPage.phone && !state.hasError) phoneNumber = value;
    return !state.hasError;
  }
}

mixin SignInValidators {
  final phoneSubmitValidators = [
    NonEmptyStringValidator('Phone number can\'t be empty'.hardcoded),
    NumberStringValidator('Phone number can only contain numbers'.hardcoded),
  ];

  final codeSubmitValidators = [
    ExactLengthStringValidator(
      'Code must have 6 characters'.hardcoded,
      length: 6,
    ),
  ];

  final nameSubmitValidators = [
    NonEmptyStringValidator('Name can\'t be empty'.hardcoded),
  ];
}

extension SignInControllerX on SignInController {
  String? phoneNumberErrorText(String phoneNumber) => phoneSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(phoneNumber))
      ?.errorText;

  String? codeErrorText(String code) => codeSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(code))
      ?.errorText;

  String? nameErrorText(String name) => nameSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(name))
      ?.errorText;
}
