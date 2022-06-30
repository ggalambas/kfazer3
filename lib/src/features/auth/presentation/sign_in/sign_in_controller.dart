import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_validators.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

import 'sign_in_screen.dart';

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInController(authRepository: authRepository);
});

class SignInController extends StateNotifier<AsyncValue> with SignInValidators {
  final AuthRepository authRepository;

  SignInController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<bool> submit(SignInPage page, String value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      switch (page) {
        case SignInPage.phone:
          return authRepository.sendSmsCode(value);
        case SignInPage.verification:
          return authRepository.verifySmsCode(value);
        case SignInPage.account:
          return authRepository.createAccount(value);
      }
    });
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
