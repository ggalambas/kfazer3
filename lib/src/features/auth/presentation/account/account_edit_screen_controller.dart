import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
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
    state = await AsyncValue.guard(() => _authRepository.updateUser(user));
    //TODO save account image

    // save image into storage
    // get image url
    // update appuser photoUrl
    // update account
  }
}

mixin AccountValidators {
  List<StringValidator> phoneSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidPhoneNumberEmpty),
        NumberStringValidator(context.loc.invalidPhoneNumberOnlyNumbers),
      ];

  List<StringValidator> nameSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidNameEmpty),
      ];
}

extension AccountValidatorsText on AccountValidators {
  String? phoneNumberErrorText(BuildContext context, String phoneNumber) =>
      phoneSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(phoneNumber))
          ?.errorText;

  String? nameErrorText(BuildContext context, String name) =>
      nameSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
