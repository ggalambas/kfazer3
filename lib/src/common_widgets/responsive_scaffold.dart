import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:smart_space/smart_space.dart';

export 'rail.dart';

/// Responsive layout that shows
/// a rail and the body side by side if there is enough space,
/// or the standard scaffold if there is not enough space.
class ResponsiveScaffold extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Widget? rail;
  final Widget Function(double topPadding) builder;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    this.padding = EdgeInsets.zero,
    this.appBar,
    this.rail,
    required this.builder,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= Breakpoint.tablet) {
        //* HORIZONTAL VIEW
        final topPadding = constraints.maxHeight / 10;
        return Scaffold(
          body: ResponsiveCenter(
            maxContentWidth: Breakpoint.desktop,
            padding: padding,
            child: Row(
              children: [
                if (rail != null)
                  Expanded(
                    flex: 1,
                    child: ListView(
                      padding: EdgeInsets.only(top: topPadding),
                      children: [
                        rail!,
                        if (floatingActionButton != null) ...[
                          Space(2),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: floatingActionButton!,
                          ),
                        ],
                      ],
                    ),
                  ),
                Space(4),
                Expanded(flex: 2, child: builder(topPadding)),
              ],
            ),
          ),
        );
      } else {
        //* VERTICAL VIEW
        return Scaffold(
          appBar: appBar,
          body: ResponsiveCenter(
            padding: padding,
            child: builder(0),
          ),
          floatingActionButton: floatingActionButton,
        );
      }
    });
  }
}
