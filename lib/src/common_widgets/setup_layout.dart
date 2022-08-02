import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/responsive_two_column_layout.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class SetupLayout extends StatelessWidget {
  final Key? formKey;
  final String title;
  final InlineSpan description;
  final List<Widget> content;
  final List<Widget> cta;

  const SetupLayout({
    super.key,
    this.formKey,
    required this.title,
    required this.description,
    required this.content,
    required this.cta,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(kSpace * 2),
        child: ResponsiveTwoColumnLayout(
          spacing: kSpace * 2,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          startContent: Padding(
            padding: EdgeInsets.all(kSpace * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: context.textTheme.displayLarge),
                Space(2),
                Text.rich(description, style: context.textTheme.bodySmall),
              ],
            ),
          ),
          endContent: Padding(
            padding: EdgeInsets.all(kSpace * 2),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...content,
                  if (content.isNotEmpty && cta.isNotEmpty) Space(3),
                  ...cta,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
