import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'back_or_close_button.dart';

/// Responsive layout that shows
/// two child widgets side by side if there is enough space,
/// or vertically stacked if there is not enough space.
class ResponsiveSetup extends StatelessWidget {
  final Key? formKey;
  final ScrollController? controller;
  final String title;
  final String? description;
  final InlineSpan? descriptionSpan;
  final Widget content;
  final List<Widget> actions;
  final VoidCallback? onCancel;

  const ResponsiveSetup({
    super.key,
    this.formKey,
    this.controller,
    required this.title,
    this.description,
    this.descriptionSpan,
    required this.content,
    required this.actions,
    this.onCancel,
  }) : assert(description == null || descriptionSpan == null);

  bool get cancelable => onCancel != null;

  List<Widget> get alignedActions => actions
      .map((action) => Align(alignment: Alignment.centerRight, child: action))
      .toList();

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(kSpace * 4);
    final titleStyle = context.textTheme.displayLarge;
    final bodyStyle = context.textTheme.bodySmall;
    return Form(
      key: formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoint.tablet) {
          //* HORIZONTAL VIEW
          final backButton = backOrCloseButton(context);
          return Scaffold(
            body: ResponsiveCenter(
              maxContentWidth: Breakpoint.desktop,
              padding: EdgeInsets.symmetric(horizontal: padding.left),
              child: Row(
                children: [
                  Expanded(
                    child: ResponsiveCenter(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: padding.top),
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (backButton != null) backButton,
                            Text(title, style: titleStyle),
                            Space(2),
                            if (description != null)
                              Text(description!, style: bodyStyle),
                            if (descriptionSpan != null)
                              Text.rich(descriptionSpan!, style: bodyStyle),
                            Space(3),
                            if (cancelable) CancelButton(onPressed: onCancel),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Space(4),
                  Expanded(
                    child: ResponsiveCenter(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: padding.top),
                        controller: controller,
                        child: Column(
                          children: [content, Space(3), ...alignedActions],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          //* VERTICAL VIEW
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (cancelable) CancelButton(onPressed: onCancel),
              ],
            ),
            body: ResponsiveCenter(
              child: SingleChildScrollView(
                controller: controller,
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: titleStyle),
                    Space(2),
                    if (description != null)
                      Text(description!, style: bodyStyle),
                    if (descriptionSpan != null)
                      Text.rich(descriptionSpan!, style: bodyStyle),
                    Space(6),
                    content,
                    Space(3),
                    ...alignedActions,
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}

class CancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: context.colorScheme.error),
      onPressed: onPressed,
      child: Text(context.loc.cancel),
    );
  }
}
