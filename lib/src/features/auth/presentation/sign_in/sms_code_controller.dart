import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';

//TODO keep timer but dispose when finished/login/going to displayname
final smsCodeControllerProvider =
    StateNotifierProvider.family<SmsCodeController, AsyncValue<int>, String>(
  (ref, phoneNumber) {
    final authRepository = ref.watch(authRepositoryProvider);
    return SmsCodeController(phoneNumber, authRepository: authRepository);
  },
);

class SmsCodeController extends StateNotifier<AsyncValue<int>> {
  final AuthRepository authRepository;
  final String phoneNumber;
  late final Timer timer;

  SmsCodeController(this.phoneNumber, {required this.authRepository})
      : super(const AsyncValue.data(30)) {
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.value != 0) state = AsyncValue.data(state.value! - 1);
    });
  }

  Future<bool> resendSmsCode() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authRepository.sendSmsCode(phoneNumber);
      return 30;
    });
    return !state.hasError;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
