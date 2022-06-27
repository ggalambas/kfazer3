import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:ms_undraw/ms_undraw.dart';

export 'package:ms_undraw/illustrations.g.dart';

class EmptyPlaceholder extends StatelessWidget {
  final UnDrawIllustration illustration;
  final String message;

  const EmptyPlaceholder({
    super.key,
    required this.illustration,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsiveCenter(
      maxContentWidth: 300,
      child: Column(
        children: [
          const Spacer(),
          AspectRatio(
            aspectRatio: 1,
            child: UnDraw(
              illustration: illustration,
              color: theme.colorScheme.primaryContainer,
            ),
          ),
          Text(message, style: theme.textTheme.bodyLarge),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
