import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_picker_controller.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

import 'image_picker_dialog.dart';

class ImagePickerBadge extends ConsumerWidget {
  final Widget child;
  final bool showDeleteOption;
  final void Function(Uint8List? file)? onImagePicked;

  const ImagePickerBadge({
    super.key,
    this.onImagePicked,
    this.showDeleteOption = false,
    required this.child,
  });

  void openImagePickerDialog(BuildContext context, WidgetRef ref) async {
    final file = await showImagePickerDialog(
      context,
      onDelete: showDeleteOption ? null : () => onImagePicked!(null),
    );
    if (file != null) {
      final bytes = await ref
          .read(imagePickerControllerProvider.notifier)
          .readAsBytes(file);
      return onImagePicked!(bytes);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      imagePickerControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(imagePickerControllerProvider);
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          child,
          LoadingElevatedButton(
            loading: state.isLoading,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.surface,
              shape: const CircleBorder(),
              minimumSize: const Size.square(kMinInteractiveDimension),
              padding: EdgeInsets.zero,
            ),
            onPressed: onImagePicked == null
                ? null
                : () => openImagePickerDialog(context, ref),
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
