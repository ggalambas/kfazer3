import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

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
