import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class GroupListTitle extends StatelessWidget {
  final String text;
  const GroupListTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kSpace * 4,
        vertical: kSpace * 2,
      ),
      child: Text(text, style: context.textTheme.displaySmall),
    );
  }
}
