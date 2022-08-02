import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final accountDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<AccountDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return AccountDetailsScreenController(repository);
  },
);

class AccountDetailsScreenController extends StateNotifier<AsyncValue> {
  final AuthRepository _authRepository;

  AccountDetailsScreenController(this._authRepository)
      : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.deleteUser());
  }
}
