import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_picker_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// The dialog returns an [ImagePickerOption]
class ImagePickerDialog extends ConsumerStatefulWidget {
  final VoidCallback? onDelete;
  const ImagePickerDialog({super.key, this.onDelete});

  @override
  ConsumerState<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends ConsumerState<ImagePickerDialog> {
  Future<void> pickImageFromCamera() async {
    final controller = ref.read(imagePickerControllerProvider.notifier);
    final file = await controller.pickImage(source: ImageSource.camera);
    if (mounted && file != null) Navigator.of(context).pop(file);
  }

  Future<void> pickImageFromGallery() async {
    final controller = ref.read(imagePickerControllerProvider.notifier);
    final file = await controller.pickImage(source: ImageSource.gallery);
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

class ImagePickerButton extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final Color? color;
  final VoidCallback? onPressed;

  const ImagePickerButton({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            foregroundColor: color,
            side: BorderSide(color: context.theme.dividerColor),
            fixedSize: const Size.square(kMinInteractiveDimension),
          ),
          onPressed: onPressed,
          child: icon,
        ),
        Space(),
        text,
      ],
    );
  }
}
