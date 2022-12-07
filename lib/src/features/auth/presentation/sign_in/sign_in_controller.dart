import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';

import 'sign_in_screen.dart';

final signInPayloadProvider =
    Provider.autoDispose<SignInPayload>((ref) => SignInPayload());

class SignInPayload {
  PhoneNumber? phoneNumber;
  bool isCodeValid = false;
}

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>(
  (ref) {
    final payload = ref.watch(signInPayloadProvider);
    final repository = ref.watch(authRepositoryProvider);
    return SignInController(
      payload: payload,
      authRepository: repository,
      smsCodeController: (phoneNumber) =>
          ref.read(smsCodeControllerProvider(phoneNumber).notifier),
    );
  },
);

class SignInController extends StateNotifier<AsyncValue> with AuthValidators {
  final SignInPayload payload;
  final AuthRepository authRepository;
  final SmsCodeController Function(PhoneNumber phoneNumber) smsCodeController;

  final smsCodeControllers = <SmsCodeController>[];

  SignInController({
    required this.payload,
    required this.authRepository,
    required this.smsCodeController,
  }) : super(const AsyncValue.data(null));

  Future<bool> submit(SignInPage page, dynamic value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      switch (page) {
        case SignInPage.phone:
          assert(value is PhoneNumber);
          final controller = smsCodeController(value);
          smsCodeControllers.add(controller);
          await controller.sendSmsCode(throwError: true);
          payload.phoneNumber = value;
          break;
        case SignInPage.verification:
          assert(value is String);
          await authRepository.verifySmsCode(payload.phoneNumber!, value);
          payload.isCodeValid = true;
          break;
        case SignInPage.account:
          assert(value is String);
          await authRepository.createUser(payload.phoneNumber!, value);
          break;
      }
    });
    return !state.hasError;
  }

  @override
  void dispose() {
    for (final controller in smsCodeControllers) {
      controller.link.close();
    }
    super.dispose();
  }
}
