import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final accountControllerProvider =
    StateNotifierProvider.autoDispose<AccountController, AsyncValue>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return AccountController(authRepository: repository);
  },
);

class AccountController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;

  AccountController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }

  Future<void> deleteUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.deleteUser());
  }
}
