import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/back_or_close_button.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class Rail extends StatelessWidget {
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final String? title;
  final List<Widget> actions;

  const Rail({
    super.key,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final backButton = backOrCloseButton(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null)
          leading!
        else if (automaticallyImplyLeading && backButton != null)
          backButton,
        if (title != null)
          AutoSizeText(
            title!,
            style: context.textTheme.displayLarge,
            maxLines: 1,
          ),
        Space(3),
        ...actions,
      ],
    );
  }
}
