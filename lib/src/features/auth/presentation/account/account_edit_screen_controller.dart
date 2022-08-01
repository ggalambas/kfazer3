import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final accountEditScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountEditScreenController, AsyncValue>(
  (ref) {
    final repository = ref.read(authRepositoryProvider);
    return AccountEditScreenController(repository);
  },
);

class AccountEditScreenController extends StateNotifier<AsyncValue>
    with AccountValidators {
  final AuthRepository _authRepository;

  AccountEditScreenController(this._authRepository)
      : super(const AsyncValue.data(null));

  Future<void> save(AppUser user, Uint8List? imageBytes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.updateAccount(user));
    //TODO save image
    // save image into storage
    // get image url
    // update appuser photoUrl
    // update account
  }
}

mixin AccountValidators {
  final phoneSubmitValidators = [
    NonEmptyStringValidator('Phone number can\'t be empty'.hardcoded),
    NumberStringValidator('Phone number can only contain numbers'.hardcoded),
  ];

  final nameSubmitValidators = [
    NonEmptyStringValidator('Name can\'t be empty'.hardcoded),
  ];
}

extension AccountValidatorsText on AccountValidators {
  String? phoneNumberErrorText(String phoneNumber) => phoneSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(phoneNumber))
      ?.errorText;

  String? nameErrorText(String name) => nameSubmitValidators
      .firstWhereOrNull((validator) => !validator.isValid(name))
      ?.errorText;
}
