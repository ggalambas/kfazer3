import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';

final accountEditScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountEditScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return AccountEditScreenController(authRepository: repository);
  },
);

class AccountEditScreenController extends StateNotifier<AsyncValue>
    with AuthValidators {
  final AuthRepository authRepository;

  AccountEditScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));

  Future<void> save(AppUser user, Uint8List? imageBytes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.updateUser(user));
    //TODO save account image

    // save image into storage
    // get image url
    // update appuser photoUrl
    // update account
    //! update test file
  }
}
