import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInController(authRepository: authRepository);
});

enum AccountState { needsSetup, existent }

class SignInController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;

  SignInController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<bool> submitPhoneNumber(String phoneNumber) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.sendSmsCode(phoneNumber),
    );
    return !state.hasError;
  }

  Future<bool> submitSmsCode(String smsCode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.verifySmsCode(smsCode));
    return !state.hasError;
  }

  Future<bool> submitAccount(String displayName, Image? image) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.createAccount(displayName, null),
    );
    return !state.hasError;
  }
}
