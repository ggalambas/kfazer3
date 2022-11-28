import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerControllerProvider =
    StateNotifierProvider.autoDispose<ImagePickerController, AsyncValue>(
  (ref) => ImagePickerController(),
);

class ImagePickerController extends StateNotifier<AsyncValue> {
  final imagePicker = ImagePicker();
  ImagePickerController() : super(const AsyncValue.data(null));

  Future<XFile?> pickImage({required ImageSource source}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
    });
    return state.valueOrNull;
  }

  Future<Uint8List?> readAsBytes(XFile file) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => file.readAsBytes());
    return state.valueOrNull;
  }
}

  // Future<void> pickImageFromCamera() async {
  //   final controller = ref.read(imagePickerControllerProvider.notifier);
  //   final success = await controller.pickImage(source: ImageSource.camera);
  //   if (mounted && success) Navigator.of(context).pop(true);
  // }

  // Future<void> pickImageFromGallery() async {
  //   final controller = ref.read(imagePickerControllerProvider.notifier);
  //   final success = await controller.pickImage(source: ImageSource.gallery);
  //   if (mounted && success) Navigator.of(context).pop(true);
  // }