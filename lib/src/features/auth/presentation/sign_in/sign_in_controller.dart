import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';

import 'sign_in_screen.dart';

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return SignInController(
      authRepository: repository,
      smsCodeController: (phoneNumber) =>
          ref.read(smsCodeControllerProvider(phoneNumber).notifier),
    );
  },
);

class SignInController extends StateNotifier<AsyncValue> with AuthValidators {
  final AuthRepository authRepository;
  final SmsCodeController Function(PhoneNumber phoneNumber) smsCodeController;

  SignInController({
    required this.authRepository,
    required this.smsCodeController,
  }) : super(const AsyncValue.data(null));

  PhoneNumber? phoneNumber;

  Future<bool> submit(SignInPage page, dynamic value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      switch (page) {
        case SignInPage.phone:
          assert(value is PhoneNumber);
          return smsCodeController(value).sendSmsCode(throwError: true);
        case SignInPage.verification:
          assert(value is String);
          return authRepository.verifySmsCode(phoneNumber!, value);
        case SignInPage.account:
          assert(value is String);
          return authRepository.createUser(phoneNumber!, value);
      }
    });
    if (page == SignInPage.phone && !state.hasError) phoneNumber = value;
    return !state.hasError;
  }
}
