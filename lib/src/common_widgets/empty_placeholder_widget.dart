import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/primary_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends StatelessWidget {
  final String message;
  const EmptyPlaceholderWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(kSpace * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Space(4),
            PrimaryButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              text: 'Go Home'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}
