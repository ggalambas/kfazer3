import 'dart:async';

import 'package:flutter_animate/extensions/num_duration_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

final kCodeTimerDuration = 30.seconds;

final smsCodeControllerProvider = StateNotifierProvider.family
    .autoDispose<SmsCodeController, AsyncValue<int>, PhoneNumber>(
  (ref, phoneNumber) {
    final authRepository = ref.watch(authRepositoryProvider);
    return SmsCodeController(phoneNumber, authRepository: authRepository);
  },
  disposeDelay: kCodeTimerDuration,
);

class SmsCodeController extends StateNotifier<AsyncValue<int>> {
  final AuthRepository authRepository;
  final PhoneNumber phoneNumber;
  late final Timer timer;

  SmsCodeController(this.phoneNumber, {required this.authRepository})
      : super(const AsyncValue.data(0)) {
    initTimer();
  }

  bool get isTicking => (state.valueOrNull ?? 0) != 0;

  void initTimer() {
    timer = Timer.periodic(1.seconds, (timer) {
      if (isTicking) state = AsyncValue.data(state.value! - 1);
    });
  }

  Future<void> sendSmsCode({bool throwError = false}) async {
    if (isTicking) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authRepository.sendSmsCode(phoneNumber);
      return kCodeTimerDuration.inSeconds;
    });
    if (throwError && state.hasError) throw state.error!;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
