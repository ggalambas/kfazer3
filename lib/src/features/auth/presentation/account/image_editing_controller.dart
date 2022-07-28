import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageEditingControllerProvider =
    StateNotifierProvider.autoDispose<ImageEditingController, AsyncValue>(
  (ref) => ImageEditingController(),
);

class ImageEditingController extends StateNotifier<AsyncValue> {
  ImageEditingController() : super(const AsyncValue.data(null));

  Future<Uint8List?> readAsBytes(XFile file) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => file.readAsBytes());
    return state.valueOrNull;
  }
}
