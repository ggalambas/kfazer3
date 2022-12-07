import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_picker_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'image_picker_button.dart';

Future<XFile?> showImagePickerDialog(
  BuildContext context, {
  VoidCallback? onDelete,
}) =>
    showDialog<XFile>(
      context: context,
      builder: (_) => ImagePickerDialog(onDelete: onDelete),
    );

/// The dialog returns an [XFile] or [null] if no image chose
class ImagePickerDialog extends ConsumerStatefulWidget {
  final VoidCallback? onDelete;
  const ImagePickerDialog({super.key, this.onDelete});

  @override
  ConsumerState<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends ConsumerState<ImagePickerDialog> {
  Future<void> pickImageFromCamera() => pickImage(source: ImageSource.camera);
  Future<void> pickImageFromGallery() => pickImage(source: ImageSource.gallery);

  Future<void> pickImage({required ImageSource source}) async {
    final controller = ref.read(imagePickerControllerProvider.notifier);
    final file = await controller.pickImage(source: source);
    if (mounted && file != null) Navigator.of(context).pop(file);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      imagePickerControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(imagePickerControllerProvider);
    return AlertDialog(
      title: Text(context.loc.profilePhoto),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ImagePickerButton(
            icon: const Icon(Icons.camera_alt),
            text: Text(context.loc.imagePickerCamera),
            onPressed: state.isLoading ? null : pickImageFromCamera,
          ),
          ImagePickerButton(
            icon: const Icon(Icons.image),
            text: Text(context.loc.imagePickerGallery),
            onPressed: state.isLoading ? null : pickImageFromGallery,
          ),
          if (widget.onDelete != null)
            ImagePickerButton(
              icon: const Icon(Icons.delete),
              text: Text(context.loc.imagePickerDelete),
              color: context.colorScheme.error,
              onPressed: state.isLoading ? null : widget.onDelete,
            ),
        ],
      ),
    );
  }
}
