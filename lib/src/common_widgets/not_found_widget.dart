import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class NotFoundWidget extends StatelessWidget {
  final String message;
  const NotFoundWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: context.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            Space(4),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              child: Text(context.loc.goHome),
            )
          ],
        ),
      ),
    );
  }
}
