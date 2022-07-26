import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:ms_undraw/ms_undraw.dart';

export 'package:ms_undraw/illustrations.g.dart';

class EmptyPlaceholder extends StatelessWidget {
  final UnDrawIllustration illustration;
  final Color? illustrationColor;
  final String message;

  const EmptyPlaceholder({
    super.key,
    required this.illustration,
    this.illustrationColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      maxContentWidth: Breakpoint.handset,
      child: Column(
        children: [
          const Spacer(),
          AspectRatio(
            aspectRatio: 1,
            child: UnDraw(
              illustration: illustration,
              color: illustrationColor ?? context.colorScheme.primary,
            ),
          ),
          Text(message, style: context.textTheme.bodyLarge),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
