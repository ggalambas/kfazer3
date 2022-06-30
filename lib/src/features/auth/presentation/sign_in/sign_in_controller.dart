import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

import 'sign_in_screen.dart';

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
