import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'loading_button.dart';

//TODO image sizes

enum ImagePickerOption {
  camera(Icons.camera_alt),
  gallery(Icons.image),
  delete(Icons.delete);

  final IconData icon;
  const ImagePickerOption(this.icon);
}

class ImagePickerBadge extends StatelessWidget {
  final Widget child;
  final bool loading;
  final bool disabled;
  final bool showDeleteOption;
  final void Function(XFile? file)? onImagePicked;

  const ImagePickerBadge({
    super.key,
    this.loading = false,
    this.disabled = false,
    this.onImagePicked,
    this.showDeleteOption = false,
    required this.child,
  });

  void pickImage(BuildContext context) async {
    final option = await showDialog<ImagePickerOption>(
      context: context,
      builder: (context) => ImagePickerDialog(showDelete: showDeleteOption),
    );

    late final ImageSource source;
    switch (option) {
      case ImagePickerOption.camera:
        source = ImageSource.camera;
        break;
      case ImagePickerOption.gallery:
        source = ImageSource.gallery;
        break;
      case ImagePickerOption.delete:
        return onImagePicked?.call(null);
      default:
        return;
    }

    final file = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file == null) return;
    onImagePicked?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        child,
        LoadingElevatedButton(
          loading: loading,
          style: ElevatedButton.styleFrom(
            primary: context.colorScheme.surface,
            shape: const CircleBorder(),
            minimumSize: const Size.square(kMinInteractiveDimension),
            padding: EdgeInsets.zero,
          ),
          onPressed: disabled ? null : () => pickImage(context),
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }
}

class ImagePickerDialog extends StatelessWidget {
  final bool showDelete;
  const ImagePickerDialog({super.key, this.showDelete = false});

  Iterable<ImagePickerOption> get options => ImagePickerOption.values
      .where((option) => option != ImagePickerOption.delete || showDelete);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Profile photo'.hardcoded),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final option in options)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    onPrimary: option == ImagePickerOption.delete
                        ? context.colorScheme.error
                        : null,
                    side: BorderSide(color: context.theme.dividerColor),
                    fixedSize: const Size.square(
                      kMinInteractiveDimension,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, option),
                  child: Icon(option.icon),
                ),
                Space(),
                Text(option.name.hardcoded),
              ],
            ),
        ],
      ),
    );
  }
}
