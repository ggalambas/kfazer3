import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_controller.dart';
import 'package:kfazer3/src/features/auth/application/account_service.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';

final accountEditControllerProvider =
    StateNotifierProvider.autoDispose<AccountEditController, AsyncValue>(
  (ref) => AccountEditController(
    accountService: ref.read(accountServiceProvider),
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AccountEditController extends StateNotifier<AsyncValue>
    with AuthValidators {
  final AccountService accountService;
  final AuthRepository authRepository;

  AccountEditController({
    required this.accountService,
    required this.authRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> save(AppUser user, ImageController imageController) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      switch (imageController.state) {
        case ImageControllerState.none:
          return authRepository.updateUser(user);
        case ImageControllerState.updated:
          return accountService.uploadPictureAndSaveUser(
              user, imageController.bytes!);
        case ImageControllerState.removed:
          return accountService.removePictureAndSaveUser(user);
      }
    });
  }
}
