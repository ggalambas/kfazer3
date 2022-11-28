import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar/avatar.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_controller.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:smart_space/smart_space.dart';

import 'image_picker_badge.dart';

class AvatarPicker extends ConsumerWidget {
  final ImageController imageController;
  final TextEditingController textController;
  final bool disabled;

  const AvatarPicker({
    super.key,
    required this.imageController,
    required this.textController,
    this.disabled = false,
  });

  ImageProvider? get image => imageController.value;
  String get text => textController.text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiValueListenableBuilder(
      valueListenables: [imageController, textController],
      builder: (context, _, __) => ImagePickerBadge(
        onImagePicked: disabled ? null : imageController.setBytes,
        showDeleteOption: image != null,
        child: Avatar(
          radius: kSpace * 10,
          foregroundImage: image,
          text: text,
        ),
      ),
    );
  }
}
