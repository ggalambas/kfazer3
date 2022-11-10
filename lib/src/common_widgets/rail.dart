import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
    // For deciding the use of the BackButton, CloseButton or neither
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;
    final impliesDismissal = parentRoute?.impliesAppBarDismissal ?? false;
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null)
          leading!
        else if (automaticallyImplyLeading && (canPop || impliesDismissal))
          useCloseButton ? const CloseButton() : const BackButton(),
        if (title != null)
          AutoSizeText(
            title!,
            style: context.textTheme.displayLarge,
            maxLines: 1, //?
          ),
        Space(3),
        ...actions,
      ],
    );
  }
}
