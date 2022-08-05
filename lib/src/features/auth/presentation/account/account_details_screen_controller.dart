import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final accountDetailsScreenControllerProvider = StateNotifierProvider
    .autoDispose<AccountDetailsScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return AccountDetailsScreenController(authRepository: repository);
  },
);

class AccountDetailsScreenController extends StateNotifier<AsyncValue> {
  final AuthRepository authRepository;

  AccountDetailsScreenController({required this.authRepository})
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
