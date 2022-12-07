import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

extension WidgetLoader on Widget {
  /// Add a shimmer effect
  Animate loader(BuildContext context) {
    return animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: 1.seconds,
      color: context.colorScheme.primary.withOpacity(0.15),
    );
  }
}
