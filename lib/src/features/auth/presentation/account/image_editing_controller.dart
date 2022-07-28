import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageEditingControllerProvider =
    StateNotifierProvider.autoDispose<ImageEditingController, AsyncValue>(
  (ref) {
    return ImageEditingController();
  },
);

class ImageEditingController extends StateNotifier<AsyncValue> {
  ImageEditingController() : super(const AsyncValue.data(null));

  Future<Uint8List?> pickProfilePicture(ImageSource source) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: source);
      if (xfile == null) return null;
      return await xfile.readAsBytes();
    });
    return state.valueOrNull;
  }
}
