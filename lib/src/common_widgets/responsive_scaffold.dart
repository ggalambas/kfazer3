import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:smart_space/smart_space.dart';

export 'rail.dart';

/// Responsive layout that shows
/// two the appbar and the body side by side if there is enough space,
/// or the standard scaffold if there is not enough space.
class ResponsiveScaffold extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Widget? rail;
  final Widget Function(EdgeInsetsGeometry railPadding) builder;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    this.maxContentWidth = Breakpoint.tablet,
    this.padding = EdgeInsets.zero,
    this.appBar,
    this.rail,
    required this.builder,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= maxContentWidth) {
        final railPadding = EdgeInsets.only(top: constraints.maxHeight / 10);
        return Scaffold(
          body: ResponsiveCenter(
            maxContentWidth: Breakpoint.desktop,
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rail != null)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: railPadding,
                      child: rail!,
                    ),
                  ),
                Space(4),
                Expanded(flex: 2, child: builder(railPadding)),
              ],
            ),
          ),
          floatingActionButton: floatingActionButton,
        );
      } else {
        return Scaffold(
          appBar: appBar,
          body: ResponsiveCenter(
            padding: padding,
            child: builder(EdgeInsets.zero),
          ),
          floatingActionButton: floatingActionButton,
        );
      }
    });
  }
}
