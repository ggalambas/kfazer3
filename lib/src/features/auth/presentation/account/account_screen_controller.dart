import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
  (ref) => AccountScreenController(ref.read),
);

class AccountScreenController extends StateNotifier<AsyncValue>
    with AccountValidators {
  final Reader read;
  AccountScreenController(this.read) : super(const AsyncValue.data(null));

  AuthRepository get _authRepository => read(authRepositoryProvider);

  Future<void> save(AppUser user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.updateAccount(user));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
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
