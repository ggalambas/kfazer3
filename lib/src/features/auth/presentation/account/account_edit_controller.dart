import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/application/account_service.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';

final accountEditControllerProvider =
    StateNotifierProvider.autoDispose<AccountEditController, AsyncValue>(
  (ref) {
    final service = ref.read(accountServiceProvider);
    final repository = ref.read(authRepositoryProvider);
    return AccountEditController(
      accountService: service,
      authRepository: repository,
    );
  },
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
    state = await AsyncValue.guard(
      () => imageController.imageUpdated
          ? accountService.updateAccount(user, imageController.bytes)
          : authRepository.updateUser(user),
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

  bool get imageUpdated =>
      _startingUrl == null && bytes != null ||
      _startingUrl != null && (bytes != null || _url == null);

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
