import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

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
      : super(const AsyncValue.data(null));

  Future<bool> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    return !state.hasError;
  }
}
