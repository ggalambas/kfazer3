import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final signOutControllerProvider =
    StateNotifierProvider.autoDispose<SignOutController, AsyncValue>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return SignOutController(authRepository: authRepository);
  },
);

class SignOutController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;

  SignOutController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AccountScreenController(authRepository: authRepository);
  },
);

class AccountScreenController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;

  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(false));

  void edit() => state = const AsyncValue.data(true);

  Future<bool> save(String name, String phoneNumber) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await authRepository.changeUserInfo(
          displayName: name,
          phoneNumber: phoneNumber,
        );
        return false;
      },
    );
    return !state.hasError;
  }
}
