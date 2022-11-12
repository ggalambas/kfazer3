import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  //TODO refact this logic and image controller
  // make same changes on group edit
  Future<void> save(AppUser user, ImageController imageController) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () {
        if (imageController.imageUpdated) {
          return accountService.uploadPictureAndSaveUser(
              user, imageController.bytes!);
        } else if (imageController.imageRemoved) {
          return accountService.removePictureAndSaveUser(user);
        } else {
          return authRepository.updateUser(user);
        }
      },
    );
  }
}

//TODO create a file for this

class ImageController extends ValueNotifier<ImageProvider?> {
  ImageProvider? get image => value;

  ImageController({String? url})
      : _startingUrl = url,
        _url = url,
        super(_imageFromUrl(url));

  final String? _startingUrl;
  String? _url;

  bool get imageRemoved =>
      _startingUrl != null && bytes == null && _url == null;
  bool get imageUpdated => bytes != null;

  Uint8List? _bytes;
  Uint8List? get bytes => _bytes;
  set bytes(Uint8List? newBytes) {
    _bytes = newBytes;
    value = _imageFromBytes(newBytes);
  }

  void clear() {
    _bytes = null;
    _url = null;
    value = null;
  }

  static NetworkImage? _imageFromUrl(String? url) =>
      url == null ? null : NetworkImage(url);
  static MemoryImage? _imageFromBytes(Uint8List? bytes) =>
      bytes == null ? null : MemoryImage(bytes);
}
