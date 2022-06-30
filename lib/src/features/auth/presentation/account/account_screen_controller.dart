import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AccountScreenController(authRepository: authRepository);
  },
);

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;

  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
