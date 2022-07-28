import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

const _kTimerDuration = Duration(seconds: 30);

final smsCodeControllerProvider = StateNotifierProvider.family
    .autoDispose<SmsCodeController, AsyncValue<int>, PhoneNumber>(
  (ref, phoneNumber) {
    final authRepository = ref.watch(authRepositoryProvider);
    return SmsCodeController(phoneNumber, authRepository: authRepository);
  },
  disposeDelay: _kTimerDuration,
);

class SmsCodeController extends StateNotifier<AsyncValue<int>> {
  final AuthRepository authRepository;
  final PhoneNumber phoneNumber;
  late final Timer timer;

  SmsCodeController(this.phoneNumber, {required this.authRepository})
      : super(const AsyncValue.data(0)) {
    _initTimer();
  }

  bool get _isTicking => state.value != 0;

  void _initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTicking) state = AsyncValue.data(state.value! - 1);
    });
  }

  Future<void> sendSmsCode() async {
    if (_isTicking) return;
    await authRepository.sendSmsCode(phoneNumber);
    state = AsyncValue.data(_kTimerDuration.inSeconds);
  }

  Future<bool> resendSmsCode() async {
    if (_isTicking) return true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authRepository.sendSmsCode(phoneNumber);
      return _kTimerDuration.inSeconds;
    });
    return !state.hasError;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
