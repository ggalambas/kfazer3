import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/account/editing_account_screen_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

import 'sign_in_screen.dart';

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>(
  (ref) => SignInController(read: ref.read),
);

class SignInController extends StateNotifier<AsyncValue>
    with SignInValidators, AccountValidators {
  final Reader read;
  PhoneNumber? phoneNumber;

  SignInController({required this.read}) : super(const AsyncValue.data(null));

  AuthRepository get authRepository => read(authRepositoryProvider);

  Future<bool> submit(SignInPage page, dynamic value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      switch (page) {
        case SignInPage.phone:
          assert(value is PhoneNumber);
          return read(smsCodeControllerProvider(value).notifier).sendSmsCode();
        case SignInPage.verification:
          assert(value is String);
          return authRepository.verifySmsCode(phoneNumber!, value);
        case SignInPage.account:
          assert(value is String);
          return authRepository.createAccount(phoneNumber!, value);
      }
    });
    if (page == SignInPage.phone && !state.hasError) phoneNumber = value;
    return !state.hasError;
  }
}

mixin SignInValidators {
  final codeSubmitValidators = [
    ExactLengthStringValidator(
      'Code must have 6 characters'.hardcoded,
      length: 6,
    ),
  ];
}

extension SignInValidatorsText on SignInValidators {
  String? codeErrorText(String code) => codeSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(code))
      ?.errorText;
}
